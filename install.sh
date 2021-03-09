#!/bin/bash

#ENV
name="skeleton"
file="skeleton.sh"

green="\e[0;32m\033[1m"
red="\e[0;31m\033[1m"
blue="\e[0;34m\033[1m"
yellow="\e[0;33m\033[1m"
purple="\e[0;35m\033[1m"
turquoise="\e[0;36m\033[1m"
gray="\e[0;37m\033[1m"
end="\033[0m\e[0m"

public_ip=$(wget -qO- ipinfo.io/ip)
current_interface=$(ip route get 8.8.8.8 | awk -- '{printf $5}')
currnet_local_ip=$(hostname -I)

#FUNCTIONS

## Check if is root
function is_root() {
    if [ $(id -u) = 0 ]; then
        return 0
    else
        return 1
    fi
}

## Install current file $file in /usr/local/bin
function install() {
    if ! is_root; then
        echo
        echo -e "${red}[-] You must be root${end}"
        echo
        exit 0
    fi

    echo
    if [ -d /usr/local/bin ]; then
        cp $file /usr/local/bin/$name
        echo -e "${green}[+] Installed${end}"
    else
        echo -e "${red}[-] Not found /usr/local/bin${end}"
    fi
    echo
}

## Check if install dependencies, need array

## programs=(nano apache2)
## dependencies ${programs[@]}

function dependencies() {
    if ! is_root; then
        echo
        echo -e "${red}[-] You must be root${end}"
        echo
        exit 0
    fi

    dependencies=$@

    echo
    echo -e "${yellow}[*]Check dependencies...${end}"
    echo
    sleep 1
    for package in $dependencies; do

    echo 

        if [ ! $(command -v $package) ]; then

            echo
            echo -e "${yellow}[~] Downloading $package ${end}"
            echo
            apt-get install $package -y

        else
            echo
            echo -e "${green}[+] $package is already installed ${end}"
            echo
        fi
    done
}

#MAIN
packages=(nautilus git)

dependencies ${packages[@]}

for i in $(ls /home);do


    cp ${PWD}/.developer_tools /home/$i/.developer_tools

    if [ ! $(cat /home/$i/.bashrc | grep "#developer_tools") ];then    
        echo "#developer_tools" >> /home/$i/.bashrc
        echo ". ./.developer_tools" >> /home/$i/.bashrc
    fi

    chown $i:$i /home/$i/.developer_tools

    echo -e "${green}[+] Developer_tools installed in $i ${end}"

done



