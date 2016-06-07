#!/bin/bash
USER=$1
IP=$2
FALLBACK=$3
FALLPWD=$4
echo "generating fallback user with Username $FALLBACK and password $FALLPWD."
echo "adding user $FALLBACK to sudoers file."
echo "KEEP THIS PASSWORD SECRET. $FALLBACK HAS UNLIMITED ACCCESS TO YOUR SYSTEM!"
sleep 5
ssh -t $USER@$IP "
if id $FALLBACK > /dev/null 2>&1; then
  echo ''
else
  sudo adduser $FALLBACK --home /home/$FALLBACK --gecos '' --shell /bin/bash --disabled-password;
  echo $FALLPWD | sudo passwd $FALLBACK --stdin;
fi;
echo '$FALLBACK  ALL=(ALL:ALL) ALL' >> /etc/sudoers;
"
ssh -t $USER@$IP
"sudo  printf '%s\n %s\n' 'Match User !$FALLBACK' 'Password Authentication no' >> etc/ssh/sshd_config;
  service ssh restart";
exit 0;
