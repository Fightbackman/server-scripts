#!/bin/bash
USER=$1;
IP=$2;

ssh -t $USER@$IP '
  sudo apt-get -y install python;
  sudo apt-get -y install python3;';
