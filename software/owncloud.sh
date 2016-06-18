#!/bin/bash
USER=$1;
IP=$2;
DOMAIN=$3;

ssh -t $USER@$IP '
  wget -nv https://download.owncloud.org/download/repositories/stable/Debian_8.0/Release.key -O Release.key
  sudo apt-key add - < Release.key;
  sudo echo "deb http://download.owncloud.org/download/repositories/stable/Debian_8.0/ /" >> /etc/apt/sources.list.d/owncloud.list;
  sudo apt-get update;
  sudo apt-get -y install owncloud;
  sudo ln -s /usr/share/owncloud/ /var/www/html/owncloud;';

#nginx config for owncloud#
../general-purpose/createNginxDomain.sh $USER $IP $DOMAIN owncloud owncloud.site.de;

#mysql create user and tables
read -s -p 'Enter Password of Owncloud Mysql User: ' mypassword ;
ssh -t $USER@$IP "
echo \"CREATE USER 'owncloud'@'localhost' IDENTIFIED BY '\"'$mypassword'\"';\" > create.sql;
echo \"CREATE DATABASE owncloud;\" >> create.sql;
echo \"GRANT ALL PRIVILEGES ON owncloud.* TO 'owncloud'@'localhost';\" >> create.sql;
echo \"FLUSH PRIVILEGES;\" >> create.sql;
mysql -u root -p < create.sql;
rm create.sql;
"
exit 0;
#open browser and configure
