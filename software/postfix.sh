#!/bin/bash
USER=$1;
IP=$2;

ssh -t $USER@$IP '
  sudo apt-get install postfix postfix-mysql;
  sudo apt-get --purge remove "exim4*";';
