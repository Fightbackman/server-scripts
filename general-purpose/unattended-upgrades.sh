#!/bin/bash
USER=$1; IP=$2; ssh -t $USER@$IP "
sudo apt install unattended-upgrades;
sudo sed -i '71 s/^.//' /etc/apt/apt.conf.d/50unattended-upgrades;
sudo sed -i '71 s/^.//' /etc/apt/apt.conf.d/50unattended-upgrades;
sudo touch /etc/apt/apt.conf.d/20auto-upgrades;
echo "APT::Periodic::Update-Package-Lists "1";" | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades;
echo "APT::Periodic::Unattended-Upgrade "1";" | sudo tee -a /etc/apt/apt.conf.d/20auto-upgrades;
sudo unattended-upgrade;"
exit 0;
