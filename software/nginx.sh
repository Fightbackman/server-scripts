#!/bin/bash
USER=$1;
IP=$2;

#install nginx
ssh -t $USER@$IP '
  sudo apt-get update;
  sudo apt-get upgrade;
  sudo apt-get install htop;
  sudo apt-get install nginx;
  sudo apt-get install php5-fpm;
  sudo service nginx start;
  sudo service php5-fpm restart;'

#configure nginx
scp -r ../configs/nginx-configs/ $USER@$IP:~/;
rm -rf nginx-configs/;

./diffie-hellman.sh $USER $IP;

#customization needed
ssh -t $USER@$IP '
  sudo rm -rf ~/etc/nginx/*;
  sudo mv ~/nginx-configs/* /etc/nginx/;
  sudo rm -rf /var/www;
  sudo ln -s /usr/share/nginx/ /var/www;
  sudo mkdir /var/www/html/kevin-diehl/;
  sudo service nginx stop;
  /opt/certbot/certbot-auto certonly --test-cert -d kevin-diehl.de;';

# error because dhmparams is not in place (of course)
# ssh -t $USER@$IP 'sudo service nginx start';
