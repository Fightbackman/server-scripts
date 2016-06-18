#!/bin/bash
USER=$1;
IP=$2;

#install nginx
ssh -t $USER@$IP '
  sudo apt-get update;
  sudo apt-get upgrade;
  sudo apt-get -y install git;
  cd /opt/;
  sudo git clone https://github.com/certbot/certbot;
  sudo mkdir /etc/letsencrypt;
  sudo mkdir /etc/letsencrypt/configs/;
  sudo chown -R root:root /etc/letsencrypt;'
exit 0;
