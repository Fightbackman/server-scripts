#!/bin/bash
IP=$1;
USER=$2;

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
git clone git@gitlab.shrlck.de:team/nginx-configs.git;
scp -r nginx-configs/* root@$IP:/etc/nginx/;
rm -rf nginx-configs/;

./diffie-hellman.sh $IP $USER

#customization needed
ssh -t root@$IP '
rm -rf /var/www;
ln -s /usr/share/nginx/ /var/www;
mkdir /var/www/html/kevin-diehl/
service nginx stop;
/opt/letsencrypt/letsencrypt-auto certonly --test-cert -d kevin-diehl.de;';

# error because dhmparams is not in place (of course)
# ssh -t $USER@$IP 'sudo service nginx start';
