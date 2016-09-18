#!/bin/bash
newdomain=$2
web_service=$3
config_file=/etc/letsencrypt/configs/$1
le_path='/opt/certbot';
echo "Shutdown of $web_service"
/usr/sbin/service $web_service stop
echo "Aquiring new certificate"
$le_path/certbot-auto certonly --agree-tos --renew-by-default --standalone --standalone-supported-challenges tls-sni-01 --config $config_file
echo "Aquiring for $newdomain was successfull."
echo "Restarting $web_service"
/usr/sbin/service $web_service start
exit 0;
