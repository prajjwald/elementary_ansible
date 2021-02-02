#!/bin/bash

optstring="hfm:p"

usage() {
    cat << EOF 2>&1
Usage: $(basename $0) [-hf] [-m install_mode]
    -h: show this help message
    -f: skip initial install/update checks
    -m: pick install mode, where mode can be basic (default), dev (development packages), or all
    -p: only install packages (no desktop reconfiguration/plugin addition)
EOF
    exit 1
}

typeset -i FASTMODE_ENABLED=0;
INSTALL_MODE_ARGS="-e install_mode=basic"
PLAYBOOK_ARGS="-e packages_only=False"
#Parsing options
while getopts ${optstring} arg; do
    case ${arg} in
        h)
            usage
            ;;
        f)
            echo "fastmode enabled"
            FASTMODE_ENABLED=1;
            ;;
        m) 
            echo "Install mode is: ${OPTARG}"
            INSTALL_MODE_ARGS="-e install_mode=${OPTARG}"
            ;;
        p) 
            echo "Only installing packages (no desktop configuration)"
            PLAYBOOK_ARGS="-e packages_only=True"
            ;;
        ?)
            usage;;
    esac
done

# Run apt update once - partially also to make sure user still has root privilege when running the playbook
# Easier to do it this way so that ansible doesn't have to run with the -k flag (always asks for password)
sudo echo "Cached root credentials for package installation playbook"

if [ ${FASTMODE_ENABLED} -ne 1 ];
then
    sudo apt update
    echo "Installing some basic packages first";
    sudo apt install -y git gpg software-properties-common python3 python3-distutils python3-psycopg2 aptitude curl wget
    sudo apt -y autoremove
    #sudo apt-add-repository -yu ppa:ansible/ansible
    #the ansible dconf module needs python-psutil, but it doesn't seem to auto-install
    #we use the dconf module to set various desktop settings
    sudo apt-get install -y ansible python-psutil

    sudo apt -y upgrade

    echo -n "Checking for pip3... "
    if (type pip3 2> /dev/null);
    then
        echo "pip3 already installed";
    else
        echo "Installing ..."
        curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
        sudo python3 /tmp/get-pip.py
    fi

    #upgrade/install pip
    pip3 install --upgrade pip

    #Install/upgrade ansible from pip
    sudo python3 -m pip install ansible

    #Install flatpak community.general module
    sudo ansible-galaxy collection install community.general
fi
# End initial checks

git pull # Not making any assumptions about how this directory got created initially

echo "Running ansible"
#no need for the -K option, as we just sudo'd twice
INTERPRETER_ARGS="-e ansible_python_interpreter=/usr/bin/python3"
ansible-playbook -i localhost, -c local -b playbooks/elementary.yml ${INTERPRETER_ARGS} ${INSTALL_MODE_ARGS} ${PLAYBOOK_ARGS}
