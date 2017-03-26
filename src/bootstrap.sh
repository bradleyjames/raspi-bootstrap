#!/bin/bash

if [[ $(id -u) -ne  0 ]] 
  then echo "Run as root" 
  exit 1
fi 

if [[ -z "${IP}" ]]
  then echo "IP not defined"
  exit 1
fi

# DHCP
echo "interface wlan0

static ip_address=$IP/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1" >> /etc/dhcpcd.conf

# SSH port
sed -i.bak s/Port\ 22/Port\ 9875/g /etc/ssh/sshd_config

# Create deployer user
adduser --disabled-password deployer
echo "
deployer ALL=(ALL) NOPASSWD: ALL
Defaults:deployer !requiretty
" >> /etc/sudoers

addgroup backyardlights
adduser pi backyardlights
adduser deployer backyardlights

# Docker
curl -sSL get.docker.com | sh
systemctl enable docker # set to autostart
sudo usermod -aG docker pi # add pi user to docker group

