#!/bin/sh
while read p; do
  echo "sending Keys to $p"
  scp -P 4875 ./authorized_keys $p:~/.ssh/autorized_keys
done <./to
