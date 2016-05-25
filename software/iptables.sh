#!/bin/bash
USER=$1;
IP=$2;

#install iptables
ssh -t $USER@$IP '
  sudo apt-get update;
  sudo apt-get upgrade;
  sudo apt-get install iptables;'
  exit 0;
