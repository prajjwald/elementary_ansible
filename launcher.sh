#!/bin/bash

echo "Installing some basic packages first";

sudo apt-get update
sudo apt-get install -y git gpg software-properties-common
git pull # Not making any assumptions about how this directory got created initially
sudo apt-add-repository -yu ppa:ansible/ansible
#the ansible dconf module needs python-psutil, but it doesn't seem to auto-install
#we use the dconf module to set various desktop settings
sudo apt-get install -y ansible python-psutil
sudo apt-get -y upgrade

echo "Running ansible"
#no need for the -K option, as we just sudo'd twice
ansible-playbook -i localhost, -c local -b playbooks/elementary.yml

#Now we auto-update defaults to mailspring and firefox
#io.elementary.switchboard settings://applications/defaults 2> /dev/null
