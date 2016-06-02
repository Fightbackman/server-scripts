#!/bin/bash
USER=$1;
IP=$2;

#generate ssh key
cd ~/.ssh/;
echo "generating keypair"
ssh-keygen -t rsa -b 4096;
cat ~/.ssh/id_rsa.pub;
#copy ssh key to remote server
ssh -t $USER@$IP '
if [ ! -d ".ssh" ]; then
  mkdir .ssh;
fi'
echo "copy keypair to $IP "
scp ~/.ssh/* $USER@$IP:/home/$USER/.ssh/
exit 0;
