#!/bin/bash
MAIL_ADDRESS=$1
read -s -p "Please insert your password: " PASSWORD;
QUERY="UPDATE virtual_users SET password=CONCAT('{SHA256-CRYPT}', ENCRYPT ('$PASSWORD', CONCAT('\$5\$', SUBSTRING(SHA(RAND()), -16)))) WHERE email='$MAIL_ADDRESS';";
echo "Mysql mailmanager password required:";
mysql -u mailmanager -p -D "mailserver" -e "$QUERY";
exit 0;
