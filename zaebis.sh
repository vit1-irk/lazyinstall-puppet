#!/bin/bash

if [ $UID != 0 ]; then
        echo "you need to be root"
        exit
fi
source /etc/profile

if [ -n "`which apt-get`" ]; then apt-get -y install git ansible;
elif [ -n "`which pacman`" ]; then pacman -Sy --needed --noconfirm git ansible; fi

if [ -d ".git" ]; then
    echo "we are inside git repo"
else
    echo $?
    echo "we are not inside git repo, clone and CD"
    git clone https://github.com/vit1-irk/lazyinstall-puppet
    cd lazyinstall-puppet
fi

if [ "$2" = "test" ]; then
    echo "test case, not doing git pull"
else
    git pull
fi

cd playbooks

ansible-playbook everywhere.yaml
ansible-playbook archlinuxcn.yaml

if [ "$1" = "desktop" ]; then
    ansible-playbook desktop.yaml
fi

if [ "$1" = "server" ]; then
    ansible-playbook server.yaml
fi

if [ "$1" = "science" ]; then
    ansible-playbook science.yaml
fi

if [ "$1" = "personal" ]; then
    ansible-playbook personal1.yaml
fi