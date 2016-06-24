#!/bin/sh
### This script generates an authorized_keys and distributes it to all hosts
# 1. save all public ssh keys to a directory per host
#    Example: for a trusted user username@example.com -> ./example.com/id_rsa
# 2. write all user which should acess the destination user to the file ./from. One user per line.
# 3. write all user wich you want to connect to in the file ./to. One user per line
# 4. Execute the script from a client, which is authorized to ssh to all  destination users.
#
## Arguments
# $1 specifies the port that will be used in spread_keys.sh
#
port=$1;
echo "Generate autorized keys";
sh ./gen_authorized_keys.sh;
echo "Spreading to servers";
sh ./spread_keys.sh $port;
