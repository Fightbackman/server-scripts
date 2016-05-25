#!/bin/bash
USER=$1;
IP=$2;

ssh -t $USER@$IP '
  sudo adduser teamspeak3;
  sudo mkdir /usr/local/teamspeak3;
  sudo chown teamspeak3 /usr/local/teamspeak3;
  sudo su teamspeak3 -c "
    cd /usr/local/teamspeak3;
    wget http://dl.4players.de/ts/releases/3.0.12.4/teamspeak3-server_linux_amd64-3.0.12.4.tar.bz2;
    tar -xzvf teamspeak3-server_linux*.tar.gz;
    /usr/local/teamspeak3/teamspeak3-server_linux-amd64/ts3server_minimal_runscript.sh;
    /usr/local/teamspeak3/teamspeak3-server_linux-amd64/ts3server_startscript.sh start;";';
    #last command ist to start the server
