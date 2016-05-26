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
cp -r ../configs/nginx-config .;

#mod nginx conf such that it works at least with $DOMAIN
mv nginx-config/sites/site.de nginx-config/sites/$DOMAIN;
cd nginx-config/sites/$DOMAIN/;
mv site.de $DOMAIN;
sed s/site.de/$DOMAIN/g $DOMAIN;
sed s/site.de/$DOMAIN/g ssl.conf;
rm subsite.site.de;
cd ../../../;

scp -r nginx-config/ $USER@$IP:~/;
rm -rf nginx-config;

../general-purpose/diffie-hellman.sh $USER $IP;

#customization needed
ssh -t $USER@$IP "
  sudo rm -rf ~/etc/nginx/*;
  sudo cp -r ~/nginx-config/* /etc/nginx/;
  sudo rm -rf ~/nginx-config/;
  sudo chown -R root:root /etc/nginx;
  sudo rm -rf /var/www;
  sudo ln -s /usr/share/nginx/ /var/www;
  sudo mkdir /var/www/html/$DOMAIN/;
  sudo service nginx stop;
  /opt/certbot/certbot-auto certonly --test-cert -d $DOMAIN;";

# error because dhmparams is not in place (of course)
# ssh -t $USER@$IP 'sudo service nginx start';
