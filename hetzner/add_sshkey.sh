#!/bin/bash
username=$1;
keypath=$2;

read -p "Enter password for robot REST-API:" password
if [ -t "$keypath" ]; then
keypath="$HOME/.ssh/id_rsa.pub";
echo "You entered no valid path for a key. Using your default public key instead."
fi;

pubkey=$(cat $keypath);

curl -u $username:$password https://robot-ws.your-server.de/key -d "$pubkey";

echo "Submitted your ssh key to Hetzner with the User: $username"
exit 0;
