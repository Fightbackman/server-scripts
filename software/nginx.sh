#!/bin/bash
USER=$1;
IP=$2;
DOMAIN=$3;

#install nginx
ssh -t $USER@$IP '
  sudo apt-get update;
  sudo apt-get upgrade;
  sudo apt-get install htop;
  sudo apt-get install nginx;
  sudo apt-get install php5-fpm;
  sudo service nginx start;
  sudo service php5-fpm restart;';

#configure nginx
sudo cp -r ../configs/nginx-config .;
sudo rm -rf nginx-config/sites/*;

sudo scp -r nginx-config/ $USER@$IP:~/;
sudo rm -rf nginx-config;

../general-purpose/diffie-hellman.sh $USER $IP;

#customization needed
ssh -t $USER@$IP "
  sudo rm -rf /etc/nginx/*;
  sudo cp -r ~/nginx-config/* /etc/nginx/;
  sudo rm -rf ~/nginx-config/;
  sudo chown -R root:root /etc/nginx;
  sudo rm -rf /var/www;
  sudo ln -s /usr/share/nginx/ /var/www;
  sudo mkdir /var/www/html/letsencrypt;
  sudo mkdir /var/www/html/$DOMAIN/;
  sudo service nginx stop;";

../general-purpose/createNginxDomain.sh $USER $IP $DOMAIN $DOMAIN;

ssh -t $USER@$IP "
  /opt/certbot/certbot-auto certonly --test-cert -d $DOMAIN;";

# error because dhmparams is not in place (of course)
# ssh -t $USER@$IP 'sudo service nginx start';
