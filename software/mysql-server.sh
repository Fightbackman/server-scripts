#!/bin/bash
USER=$1;
IP=$2;
ssh -t $USER@$IP '
  sudo apt-get update;
  sudo apt-get install mysql-server;';
