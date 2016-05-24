#!/bin/bash
USER=$1;
IP=$2;

ssh -t $USER@$IP '
  sudo apt-get install python;
  sudo apt-get install python3;';
