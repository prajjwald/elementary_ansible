#!/bin/bash

ANSIBLE_ELEMENTARY_TMPDIR=/tmp/ansible_elementary;
rm -rf $ANSIBLE_ELEMENTARY_TMPDIR && mkdir -p $ANSIBLE_ELEMENTARY_TMPDIR;
cd $ANSIBLE_ELEMENTARY_TMPDIR;

echo "QuickStart script for easy remote install";

sudo apt-get install -y git &&\
git clone https://github.com/prajjwald/elementary_ansible.git &&\
cd elementary_ansible &&\
./launcher.sh

cd && rm -rf $ANSIBLE_ELEMENTARY_TMPDIR;
