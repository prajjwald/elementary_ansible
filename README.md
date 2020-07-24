# Elementary Ansible

This repository contains some customizations to elementary os that I find fairly useful.

## Quick Start

```bash
git clone https://github.com/prajjwald/elementary_ansible.git
cd elementary_ansible
./launcher.sh
```

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

