#!/bin/bash
USER=$1;
IP=$2;
newUser=$3;
DOMAIN=$4;

ssh -t $USER@$IP "
  sudo adduser $newUser;
  sudo usermod -G sftp $newUser;
  sudo usermod -s /bin/false $newUser;
  sudo chown root:root /home/$newUser;
  sudo mkdir /home/$newUser/web;
  sudo chown $newUser:$newUser /home/$newUser/web;
  sudo ln -s /home/$newUser/web /var/www/html/$DOMAIN;"

exit 0;
