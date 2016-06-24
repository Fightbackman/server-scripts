#!/bin/sh
echo "">authorized_keys
while read p; do
  echo "Adding $p"
  a=$(echo $p | sed 's/.*\@//')
  cat ./$a/id_rsa.pub >> authorized_keys
done <./from
