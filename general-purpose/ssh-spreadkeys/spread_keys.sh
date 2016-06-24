#!/bin/sh
port=$1;
if [ -z $port ]; then
port=80;
fi;
while read p; do
  echo "sending Keys to $p"
  scp -P $port ./authorized_keys $p:~/.ssh/autorized_keys
done <./to
