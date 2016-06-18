#!/bin/bash
USER=$1;
IP=$2;

#install iptables
echo "installing iptables";
../software/iptables.sh $USER $IP;
echo "installing fail2ban";
../software/fail2ban.sh $USER $IP;
echo "going to disable root loging witout password if not allready done"
../general-purpose/disableRootLogin.sh $IP;
#ssh -t $USER@$IP '
#
#'
exit 0;
