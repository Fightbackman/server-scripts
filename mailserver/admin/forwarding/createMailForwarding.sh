#!/bin/bash
SOURCE=$1;
DESTINATION=$2;
SOURCE_DOMAIN=$(echo $SOURCE | grep -o "@.*" | sed -e s/@//g);
QUERY="INSERT INTO virtual_aliases (domain_id, source, destination) VALUES ( (SELECT id FROM virtual_domains WHERE name='$SOURCE_DOMAIN'), '$SOURCE', '$DESTINATION');";
mysql -u mailmanager -p -D "mailserver" -e "$QUERY";
