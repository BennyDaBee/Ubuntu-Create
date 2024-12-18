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

echo -e "${YELLOW} Installing Updates"
sudo apt-get upgrade -y
echo -e "${GREEN}Complete"

echo -e "${BLUE}Installing Wazuh"
sudo wget --inet4-only https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.7.3-1_amd64.deb && sudo WAZUH_MANAGER='172.24.10.24' dpkg -i ./wazuh-agent_4.7.3-1_amd64.deb
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
echo -e "${GREEN}Complete"

echo -e "${CYAN}Configuring Netplan"
sudo wget --inet4-only https://raw.githubusercontent.com/BennyDaBee/Ubunut-Create/main/00-installer-config.yaml -O /tmp/00-installer-config.yaml
sudo mv /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.old
sudo mv /tmp/00-installer-config.yml /etc/netplan/00-installer-config.yaml
sudo netplan apply
echo -e "${GREEN}Complete"

if grep -Fxq "HostKeyAlgorithms +ssh-rsa" /etc/ssh/sshd_config; then
echo -e "${RED}SSH Already Configured"
else
echo -e "${BLUE}Configuring SSH"
echo 'HostKeyAlgorithms +ssh-rsa' >> /etc/ssh/sshd_config
sudo systemctl restart ssh
echo -e "${GREEN}Complete"
fi

echo -e "${CYAN}Script Complete${NC}"
