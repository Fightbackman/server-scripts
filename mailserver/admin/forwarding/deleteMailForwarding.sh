#!/bin/bash
SOURCE=$1;
QUERY="DELETE FROM virtual_aliases WHERE source='$SOURCE';";
mysql -u mailmanager -p -D "mailserver" -e "$QUERY";
