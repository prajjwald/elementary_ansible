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

# 0 -> installed, non-zero (1) -> not installed
[ -f /usr/bin/textmaker18free ]; export FREEOFFICE_INSTALL_NEEDED=$?;
export CODENAME=$(awk -F= '/DISTRIB_CODENAME/ {print $2}' /etc/lsb-release);
# 0 -> not needed, non-zero (1) -> not installed
[[ "${CODENAME}" != "odin" || -f /usr/lib/x86_64-linux-gnu/wingpanel/libayatana.so ]]; export AYATANA_INSTALL_NEEDED=$?;

# Certain packages seem to take a really long time to download
# And should not hold up the rest of the install.
# Freeoffice is one of them - installing out of ansible
set_ayatana_autostart() {
    mkdir -p ~/.config/autostart /etc/skel/.config/autostart;
    cp /etc/xdg/autostart/indicator-application.desktop ~/.config/autostart/;
    sed -i 's/^OnlyShowIn.*/OnlyShowIn=Unity;GNOME;Pantheon;/' ~/.config/autostart/indicator-application.desktop;
    sudo cp ~/.config/autostart/indicator-application.desktop /etc/skel/.config/autostart;
}

download_special_packages() (
    if [ ${FREEOFFICE_INSTALL_NEEDED} -ne 0 ];
    then
        echo "Downloading freeoffice";
        wget -cq "https://www.freeoffice.com/download.php?filename=https://www.softmaker.net/down/softmaker-freeoffice-2018_976-01_amd64.deb" -O softmaker-freeoffice-2018_amd64.deb&
    fi

    if [ ${AYATANA_INSTALL_NEEDED} -ne 0 ];
    then
        echo "Downloading wingpanel ayatana";
        wget -cq "https://github.com/Lafydev/wingpanel-indicator-ayatana/raw/master/com.github.lafydev.wingpanel-indicator-ayatana_2.0.8_odin.deb" -O wingpanel-indicator-ayatana.deb&
    fi
    wait;
)

install_special_packages() (

    install_packages="";
    if [ ${FREEOFFICE_INSTALL_NEEDED} -ne 0 ];
    then
        echo "Installing freeoffice";
        install_packages="${install_packages} ./softmaker-freeoffice-2018_amd64.deb";
    fi

    if [ ${AYATANA_INSTALL_NEEDED} -ne 0 ];
    then
        echo "Installing Wingpanel Indicator Ayatana";
        install_packages=" libwingpanel-dev indicator-application ${install_packages} ./wingpanel-indicator-ayatana.deb";
    fi

    sudo apt install -y ${install_packages};

    if [ ${FREEOFFICE_INSTALL_NEEDED} -ne 0 ];
    then
        echo "Adding Freeoffice Repository to Apt Sources"
        sudo /usr/share/freeoffice2018/add_apt_repo.sh;
    fi


)

download_special_packages&

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
    #Remove ansible if already installed - we will install from pip later
    sudo apt remove -y ansible 

    echo "Installing some basic packages first";
    sudo apt install -y git gpg software-properties-common python3 python3-distutils python3-psycopg2 aptitude curl wget python3-psutil

    sudo apt -y upgrade
    sudo apt -y autoremove

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
#No need to print out the skipped tasks
export ANSIBLE_DISPLAY_SKIPPED_HOSTS=false
#no need for the -K option, as we just sudo'd twice
INTERPRETER_ARGS="-e ansible_python_interpreter=/usr/bin/python3"
ansible-playbook -i localhost, -c local -b playbooks/elementary.yml ${INTERPRETER_ARGS} ${INSTALL_MODE_ARGS} ${PLAYBOOK_ARGS}

# Wait for any outstanding downloads
echo "Now waiting for ongoing downloads - leave this terminal open"
wait;
install_special_packages;

# Launch plank in case the user ran this on ubuntu and did not have plank started by default
plank&
