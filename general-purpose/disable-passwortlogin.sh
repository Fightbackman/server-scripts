#!/bin/bash
$USER = $1
$IP = $2
$FALLBACK = $3
$FALLPWD = $4
echo "generating fallback user with Username $FALLBACK and password $FALLPWD."
echo "adding user $FALLBACK to sudoers file."
echo "KEEP THIS PASSWORD SECRET. $FALLBACK HAS UNLIMITED ACCCESS TO YOUR SYSTEM!"
wait(5000)
ssh -t $USER@$IP "
if id $FALLBACK > /dev/null 2>&1; then
  echo 'user already exists';
  exit 1;
fi
sudo adduser $FALLBACK --home /home/$FALLBACK --gecos '' --shell /bin/bash --disabled-password;
echo $FALLPWD | sudo passwd $FALLBACK --stdin;
echo '$FALLBACK  ALL=(ALL:ALL) ALL' >> /etc/sudoers;
"
ssh -t $USER@$IP s
sudo  printf '%s\n %s\n' 'Match User !$FALLBACK' 'Password Authentication no' >> etc/ssh/sshd_config;
  service ssh restart";
