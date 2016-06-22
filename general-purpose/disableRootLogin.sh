#!/bin/bash
USER=root;
IP=$2;

ssh -t $USER@$IP '
  sed -i.bak "s/^\(PermitRootLogin \).*/\1no/" /etc/ssh/sshd_config;
  service ssh restart';
exit 0;
