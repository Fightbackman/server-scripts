#!/bin/bash
USER=$1;
IP=$2;
#on remote
ssh -t root@$IP "
adduser $USER --ingroup sudo --shell /bin/bash;
apt-get update;
apt-get upgrade;
apt-get install sudo"

#install ssh key
ssh-copy-id $USER@$IP;

#install bash config
scp ~/.bash_profile $USER@$IP:~/;
scp ~/.bash_prompt $USER@$IP:~/;
scp ~/.aliases $USER@$IP:~/;
exit 0;
