#!/bin/bash
USER=$1;
IP=$2;
ssh -t $USER@$IP '
cd /opt/ || exit -1;
sudo git clone https://github.com/fightbackman/server-scripts/;
find /opt/server-scripts -type f -exec sudo chmod 755 {} \;;
find /opt/server-scripts/ -iname "*.sh" -type f -exec sudo chmod 755 {} \;;';

exit 0;
