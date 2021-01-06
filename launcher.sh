#!/bin/bash

echo "Installing some basic packages first";

sudo apt update
sudo apt install -y git gpg software-properties-common python3 python3-distutils python3-psycopg2 aptitude curl wget
sudo apt -y autoremove
git pull # Not making any assumptions about how this directory got created initially
#sudo apt-add-repository -yu ppa:ansible/ansible
#the ansible dconf module needs python-psutil, but it doesn't seem to auto-install
#we use the dconf module to set various desktop settings
#sudo apt-get install -y ansible python-psutil

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

#Install/upgrade ansible from pip
sudo python3 -m pip install ansible

#Install flatpak community.general module
sudo ansible-galaxy collection install community.general

echo "Running ansible"
#no need for the -K option, as we just sudo'd twice
ansible-playbook -i localhost, -c local -b playbooks/elementary.yml -e 'ansible_python_interpreter=/usr/bin/python3'