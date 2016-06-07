#!/bin/bash
USER=$1;
IP=$2;
DOMAIN=$3;
MAINDOMAIN=$(echo $DOMAIN | sed -E 's/.*\.([^.]+\.[^.]+)$/\1/'); #in case $DOMAIN is in the format "site.de" => MAINDOMAIN = DOMAIN
WWWPATH=$4;

echo "creating folder site";
mkdir sites/;
echo "creating folder $MAINDOMAIN";
mkdir sites/$MAINDOMAIN;

#if subdomain
if [ $(echo "$DOMAIN" | grep -o "\." | wc -l) -gt 1 ]; then
  if [ $WWWPATH == 'owncloud' ];then
    cp ../configs/nginx-config/sites/site.de/owncloud.site.de sites/$MAINDOMAIN/$DOMAIN;
  else
    cp ../configs/nginx-config/sites/site.de/subsite.site.de sites/$MAINDOMAIN/$DOMAIN; #change filename to domain in the folder of the maindomain
  fi;

  sed -i.bak s/subsite.site.de/$DOMAIN/g sites/$MAINDOMAIN/$DOMAIN; #change servername etc.
  sed -i.bak s/site.de/$MAINDOMAIN/g sites/$MAINDOMAIN/$DOMAIN; # change location of ssl.conf
  sed -i.bak s/pathtosite/$WWWPATH/g sites/$MAINDOMAIN/$DOMAIN; # change location of the webcontent
else
  #if main domain than assume that there is no ssl.conf
  cp -rf ../configs/nginx-config/sites/site.de/* sites/$DOMAIN/; #get the config folder
  rm sites/$DOMAIN/subsite.site.de; #rm the subsite because not needed here
  mv sites/$DOMAIN/site.de sites/$DOMAIN/$DOMAIN; #change main conf file "site.de" to $DOMAIN
  sed -i.bak s/site.de/$DOMAIN/g sites/$DOMAIN/$DOMAIN; #change servername etc.
  sed -i.bak s/pathtosite/$WWWPATH/g sites/$DOMAIN/$DOMAIN; #change pathto website
  sed -i.bak s/site.de/$DOMAIN/g sites/$DOMAIN/ssl.conf; #change ssl cert location in ssl.conf
fi;

rm -rf sites/$MAINDOMAIN/*.bak;
scp -r sites/$MAINDOMAIN $USER@$IP:~/;

ssh -t $USER@$IP "
  if [ -d \"/etc/nginx/sites/$MAINDOMAIN\" ]; then
    sudo cp -rf $MAINDOMAIN/* /etc/nginx/sites/$MAINDOMAIN/;
  else
    sudo cp -rf $MAINDOMAIN /etc/nginx/sites/$MAINDOMAIN;
  fi;
  sudo nginx -s reload;
  rm -rf $MAINDOMAIN;";

rm -rf sites;
