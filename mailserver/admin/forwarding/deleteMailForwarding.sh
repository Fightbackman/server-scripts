#!/bin/bash
SOURCE=$1;
QUERY="DELETE FROM virtual_aliases WHERE source='$SOURCE';";
echo "Mysql mailmanager password required:";
mysql -u mailmanager -p -D "mailserver" -e "$QUERY";
exit 0;
