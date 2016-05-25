#!/bin/bash
USER=$1;
IP=$2;

#generate ssh key
ssh -t $USER@$IP '
cd .ssh/;
ssh-keygen -t rsa -b 4096;
cat ~/.ssh/id_rsa.pub;'
