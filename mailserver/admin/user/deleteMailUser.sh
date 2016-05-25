#!/bin/bash
MAIL_ADDRESS_TO_DELETE=$1;
QUERY="DELETE FROM virtual_users WHERE email='$MAIL_ADDRESS_TO_DELETE';";
mysql -u mailmanager -p -D "mailserver" -e "$QUERY";
