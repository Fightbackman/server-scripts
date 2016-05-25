#!/bin/bash
MAIL_ADDRESS=$1;
MAIL_ADDRESS_DOMAIN=$(echo $MAIL_ADDRESS | grep -o "@.*" | sed -e s/@//g);
read -s -p "Please insert your password: " PASSWORD;
QUERY="INSERT INTO virtual_users (domain_id, email, password) VALUES ( (SELECT id FROM virtual_domains WHERE name='$MAIL_ADDRESS_DOMAIN'), '$MAIL_ADDRESS',CONCAT('{SHA256-CRYPT}', ENCRYPT ('$PASSWORD', CONCAT('\$5\$', SUBSTRING(SHA(RAND()), -16)))));";
echo "Mysql mailmanager password required:";
mysql -u mailmanager -p -D "mailserver" -e "$QUERY";
