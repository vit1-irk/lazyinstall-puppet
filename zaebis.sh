#!/bin/bash

if [ $UID != 0 ]; then
        echo "you need to be root"
        exit
fi
source /etc/profile

if [ -n "`which apt-get`" ]; then
        apt-get -y install git
        apt-get -y purge puppet
        source /etc/os-release
        if [ "$VERSION_CODENAME" = "jammy" ]; then
                VERSION_CODENAME="focal";
        fi
        wget https://apt.puppet.com/puppet7-release-$VERSION_CODENAME.deb -O puppet7-release-$VERSION_CODENAME.deb
        dpkg -i puppet7-release-$VERSION_CODENAME.deb;
        apt-get update
        apt-get -y install puppet-agent
        export PATH=$PATH:/opt/puppetlabs/bin
elif [ -n "`which pacman`" ]; then pacman -Sy --needed --noconfirm git puppet; fi

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

./puppet-module.sh

puppetpath=".:/etc/puppetlabs/code/environments/production/modules:/etc/puppetlabs/code/modules:/etc/puppet/code/modules"

if [ "$1" = "desktop" ]; then
        puppet apply --modulepath="$puppetpath" desktop.pp
fi

if [ "$1" = "server" ]; then
        puppet apply --modulepath="$puppetpath" server.pp
fi

if [ "$1" = "science" ]; then
        puppet apply --modulepath="$puppetpath" science.pp
fi
