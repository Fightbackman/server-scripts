#!/bin/bash
USER=$1;
IP=$2;

#install fail2ban
ssh -t $USER@$IP '
  sudo apt-get update;
  sudo apt-get upgrade;
  sudo apt-get -y install fail2ban;'
  exit 0;
