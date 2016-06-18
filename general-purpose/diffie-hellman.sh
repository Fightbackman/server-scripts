#!/bin/bash
USER=$1;
IP=$2;

#scp ../Slack/postToSlack.sh $USER@$IP:~/;

scp ../general-purpose/diffie-hellman-background.sh $USER@$IP:~/;

ssh -t $USER@$IP 'sudo apt-get install curl;';

ssh -t $USER@$IP "sudo su -c \"chmod +x /home/$USER/diffie-hellman-background.sh; nohup /home/$USER/diffie-hellman-background.sh > ~/diffie.log 2>&1 & exit\" "
rt=$?
if [[ $rt != 0 ]]; then
  exit 1;
else
  exit 0;
fi
