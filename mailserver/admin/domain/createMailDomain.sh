#!/bin/bash
NEW_DOMAIN=$1;
QUERY="INSERT INTO virtual_domains (name) VALUES ('$NEW_DOMAIN');";
echo "Mysql mailmanager password required:";
mysql -u mailmanager -p -D "mailserver" -e "$QUERY";
exit 0;
