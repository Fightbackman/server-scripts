#!/bin/bash
USER=$1;
IP=$2;

#install docker
ssh -t $USER@$IP '
  sudo apt-get purge lxc-docker*;
  sudo apt-get purge docker.io*;
  sudo apt-get update;
  sudo apt-get -y install apt-transport-https ca-certificates;
  sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D;
  sudo rm /etc/apt/sources.list.d/docker.list;
  sudo touch /etc/apt/sources.list.d/docker.list;
  echo "deb https://apt.dockerproject.org/repo debian-jessie main" | sudo tee -a /etc/apt/sources.list.d/docker.list;
  sudo apt-get update;
  sudo apt-cache policy docker-engine;
  sudo apt-get update;
  sudo apt-get -y install docker-engine;
  sudo service docker start;'
