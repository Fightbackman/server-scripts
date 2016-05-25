#!/bin/bash
DOMAIN_TO_DELETE=$1;
QUERY="DELETE FROM virtual_domains where name='$DOMAIN_TO_DELETE';";
echo "Mysql mailmanager password required:";
mysql -u mailmanager -p -D "mailserver" -e "$QUERY";
