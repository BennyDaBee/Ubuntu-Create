#!/bin/bash
BLUE='\033[0;34m'
WHITE='\033[0;37m'
RED='\033[0;31m'
NC='\033[0m'

if systemctl --all --type service | grep -q 'ajenti'; then
echo -e "${BLUE}Ajenti is Installed"
else
echo -e "${RED}Installing Ajenti"
curl https://raw.githubusercontent.com/ajenti/ajenti/master/scripts/install.sh | sudo bash -s -
fi

if systemctl --all --type service | grep -q 'docker'; then
echo -e "${BLUE}Docker is Installed"
else
echo -e "${RED}Installing Docker"
sudo apt-get -y install docker.io
sudo snap install docker
sudo groupadd docker
sudo usermod -aG docker bennythebee
newgrp docker
fi

if grep -Fxq "HostKeyAlgorithms +ssh-rsa" /etc/ssh/sshd_config then
echo -e "${BLUE}SSH Already Configured"
else
echo -e "${RED}Configuring SSH"
echo 'HostKeyAlgorithms +ssh-rsa' >> /etc/ssh/sshd_config
sudo systemctl restart ssh
fi

echo -e "${NC}Script Complete"
