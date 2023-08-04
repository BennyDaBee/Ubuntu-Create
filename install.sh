#!/bin/bash
BLUE='\033[0;34m'
WHITE='\033[0;37m'
RED='\033[0;31m'
NC='\033[0m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'

echo -e "${BLUE}Disabling IPv6"
touch /etc/sysctl.d/60-custom.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.d/60-custom.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.d/60-custom.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.d/60-custom.conf
sudo sysctl -p
sudo systemctl restart procps
echo -e "${GREEN}Complete"

echo -e "${YELLOW}Setting Time Zone to CST"
sudo timedatectl set-timezone America/Chicago
echo -e "${GREEN}Complete"

echo -e "${RED} Installing Updates"
sudo apt-get upgrade -y
echo -e "${GREEN}Complete"

if grep -Fxq "HostKeyAlgorithms +ssh-rsa" /etc/ssh/sshd_config; then
echo -e "${BLUE}SSH Already Configured"
else
echo -e "${RED}Configuring SSH"
echo 'HostKeyAlgorithms +ssh-rsa' >> /etc/ssh/sshd_config
sudo systemctl restart ssh
echo -e "${GREEN}Complete"
fi

echo -e "${CYAN}Script Complete${NC}"
