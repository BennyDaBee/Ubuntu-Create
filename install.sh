#!/bin/bash
BLUE='\033[0;34m'
WHITE='\033[0;37m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Disabling IPv6"
touch /etc/sysctl.d/60-custom.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.d/60-custom.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.d/60-custom.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.d/60-custom.conf
sudo sysctl -p
sudo systemctl restart procps

echo -e "${RED} Installing Updates"
sudo apt-get upgrade -y

if systemctl --all --type service | grep -q 'docker'; then
echo -e "${BLUE}Docker is Installed"
else
echo -e "${RED}Installing Docker"
sudo apt-get -y install docker.io
sudo snap install docker
sudo groupadd docker
sudo usermod -aG docker $SUDO_USER
newgrp docker
fi

if grep -Fxq "HostKeyAlgorithms +ssh-rsa" /etc/ssh/sshd_config; then
echo -e "${BLUE}SSH Already Configured"
else
echo -e "${RED}Configuring SSH"
echo 'HostKeyAlgorithms +ssh-rsa' >> /etc/ssh/sshd_config
sudo systemctl restart ssh
fi

echo -e "${NC}Script Complete"
