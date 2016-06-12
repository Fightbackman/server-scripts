#!/bin/bash
USER=$1;
IP=$2;

#install nginx
ssh -t $USER@$IP '
  sudo apt-get update;
  sudo apt-get upgrade;
  sudo apt-get install git;
  cd /opt/;
  sudo git clone https://github.com/certbot/certbot;
  sudo mkdir /etc/letsencrypt/configs/;' #update this
