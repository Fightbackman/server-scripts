#!/bin/bash
USER=$1;
IP=$2;

scp ../Slack/postToSlack.sh $USER@$IP:~/;
scp helpers/diffie-hellman-background.sh $USER@$IP:~/;

ssh -t $USER@$IP 'sudo apt-get install curl;';

ssh $USER@$IP "sudo chmod +x ~/diffie-hellman-background.sh; sudo nohup ~/diffie-hellman-background.sh > diffie.log 2>&1 & exit"
