#!/bin/bash

configname=$1
newdomain=$2
web_service='nginx'
config_file=$3
le_path='/opt/certbot'

if [ ! -f $config_file ]; then
echo "Config file does not exist"
exit 1;
fi
config_file="/etc/letsencrypt/configs/$configname"
echo "The Used config file is: $config_file"
echo "Adding domain to existing config."
sed "16s/$/, $newdomain/" $config_file > $config_file.tmp
mv $config_file.tmp $config_file
echo "Shutdown of $web_service"
/usr/sbin/service $web_service stop
echo "Aquiring new certificate"
$le_path/certbot-auto certonly --agree-tos --renew-by-default --standalone --standalone-supported-challenges tls-sni-01 --config $config_file
echo "Aquiring for $newdomain was successfull."
echo "Restarting $web_service"
exit 0;
