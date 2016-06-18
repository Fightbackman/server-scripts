#!/bin/bash
USER=$1;
IP=$2;
scp ../configs/systemd/teamspeak3.service $USER@$IP:/home/$USER/;
echo "You will finde the serveradmin key inthe file first_run.txt in the install folder after the script finished."
ssh -t $USER@$IP '
  sudo adduser teamspeak3;
  sudo mkdir /usr/local/teamspeak3;
  sudo chown teamspeak3 /usr/local/teamspeak3;
  sudo mv ~/teamspeak3.service /etc/systemd/system/;
  sudo su teamspeak3 -c "
    cd /usr/local/teamspeak3;
    wget http://dl.4players.de/ts/releases/3.0.12.4/teamspeak3-server_linux_amd64-3.0.12.4.tar.bz2;
    tar -xvjf teamspeak3-server_linux_amd64-3.0.12.4.tar.bz2;
    /usr/local/teamspeak3/teamspeak3-server_linux-amd64/ts3server_startscript.sh start; >first_run.txt
    wait 5000;
    /usr/local/teamspeak3/teamspeak3-server_linux-amd64/ts3server_startscript.sh stop;
    "
    systemctl enable teamspeak3.service;
    systemctl start teamspeak3.service';
    #last command ist to start the server
exit 0;
