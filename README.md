# Elementary Ansible

This repository contains some customizations to elementary os that I find fairly useful.

## Quick Start for One Time Users

```
wget -c https://raw.githubusercontent.com/prajjwald/elementary_ansible/master/quickstart/quickstart.sh
chmod +x quickstart.sh && ./quickstart.sh
```

<details>
  <summary>Click to expand for more details (you probably don't need this)</summary>
  
## Quick Start for Normal Users

```bash
sudo apt-get install -y git &&\
git clone https://github.com/prajjwald/elementary_ansible.git &&\
cd elementary_ansible &&\
./launcher.sh
```
## Goals

There are several goals I have in creating/maintaining this repository

* Having a quick way to get my elementary OS (re)installation get restored to a useful state for myself with minimal user interaction
* Allowing me to get new elementary installations of family and friends to a similarly 'usable' state, with certain programs, fonts, setups, etc. already in place
* Allowing me to share ideas with anyone else who might be interested


## Repository Organization

The repository can be broken down roughly as:

- the **launcher.sh** script, which you can use as a one-stop shop to install ansible and launch the playbooks
- Ansible Playbooks:
  - **elementary.yml** - master playbook
    - **elementary_packages.yml** - adds various apt repositories, and installs various packages
    - **elementary_desktop_config.yml** 
      - modifies dock items to add some useful applications to the dock (while removing some)
      - modifies keyboard shortcuts for:
        - window tiling - to more closely mimic windows 10 shortcuts (win+left/right tile windows left/right, win + ctrl + left/right change desktops)
    - ads the Nepali Keyboard layout so you can easily switch layouts using Alt + Shift

### Packages

### Elementary Packages

- planner - todo client with todoist (optional) integration
- bookworm - ebook reader
- palaura - dictionary
- screenrec - screen recorder
- notejot - sticky notes

### General Packages

- firefox
- brave

### Cloud Storage

- dropbox
- nextcloud client

### Development

- vscode
- clang/llvm/g++/make etc toolkit
- golang
- python
- git
- ...

### Entertainment/Social

- spotify
- viber
- caprine
- steam

### Productivity

- mailspring
- freeoffice
- typora

### Command Line / Power Tools

- pass
- snap
- screen
- gvim
- hackmyresume and dependencies
- ...

### Encryption

- cryfs
- encfs

### Virtualization

- docker, docker-compose
- lxd

## TODO

- Allow configurability of groups of tasks to carry out, e.g.
  - Basic Packages
  - Development + Virtualization + Power Tools
  - Desktop (Re)Configuration
  - VSCode addons installation
</details>
