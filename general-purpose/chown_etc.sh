#!bin/bash
USER=$1;
IP=$2;

ssh -t $USER@$IP '
sudo chown -R root:root /etc;
'
exit 0;
