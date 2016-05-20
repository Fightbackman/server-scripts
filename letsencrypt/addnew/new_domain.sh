#!/bin/bash

configname=$1
newdomain=$2
web_service='nginx'
config_file=$3
le_path='/opt/certboot'

if [ ! -f $config_file ]; then
config_file="/etc/letsencrypt/configs/$configname"
echo "Config file does not exist"
exit 1;
fi
config_file="/etc/letsencrypt/configs/$configname
echo "The Used config file is: $config_file"
echo "Adding domain to existing config."
sed "/$configname/s/$/ $newdomain/" $config_file
echo "Shutdown of $web_service"
/usr/sbin/service $web_service stop
echo "Aquiring new certificate"
$le_path/letsencrypt-auto certonly --agree-tos --renew-by-default --standalone --config $config_file
echo "Aquiring for $newdomain was successfull."
echo "Restarting $web_service"
exit 0;
