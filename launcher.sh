#!/bin/bash

echo "Installing some basic packages first";

sudo apt-get update
sudo apt-get install -y git gpg software-properties-common
git pull # Not making any assumptions about how this directory got created initially
sudo apt-add-repository -yu ppa:ansible/ansible
sudo apt-get install -y ansible
sudo apt-get -y upgrade

echo "Running ansible"
#no need for the -K option, as we just sudo'd twice
ansible-playbook -i localhost, -c local -b playbooks/elementary.yml

echo "######################################################################################"
echo -e "Please setup default apps now.... \n recommended:\n\tmail: mailspring\n\tweb: brave"
echo "######################################################################################"
io.elementary.switchboard settings://applications/defaults 2> /dev/null
