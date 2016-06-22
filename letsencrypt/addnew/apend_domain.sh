#!/bin/bash

configname=$1
newdomain=$2
web_service='nginx'
config_file=$3
if [ ! -f $config_file ]; then
echo "Config file does not exist"
exit 1;
fi
config_file="/etc/letsencrypt/configs/$configname"
echo "The Used config file is: $config_file"
echo "Adding domain to existing config."
sed "16s/$/, $newdomain/" $config_file > $config_file.tmp
mv $config_file.tmp $config_file
./order_domain.sh $configname $newdomain $web_service;
exit 0;
