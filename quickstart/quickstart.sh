#!/bin/bash

ANSIBLE_ELEMENTARY_TMPDIR="$HOME/tmp/ansible_elementary";

echo "QuickStart script for easy remote install";

mkdir -p "$ANSIBLE_ELEMENTARY_TMPDIR";
mv "$0" "${ANSIBLE_ELEMENTARY_TMPDIR}";
cd $ANSIBLE_ELEMENTARY_TMPDIR;

if [ -d "${ANSIBLE_ELEMENTARY_TMPDIR}/elementary_ansible" ];
then
    cd "${ANSIBLE_ELEMENTARY_TMPDIR}/elementary_ansible" && git pull;
else
    sudo apt install -y git &&\
    git clone https://github.com/prajjwald/elementary_ansible.git
fi

cd "${ANSIBLE_ELEMENTARY_TMPDIR}/elementary_ansible" &&\
./launcher.sh $*

cd; # Go back home