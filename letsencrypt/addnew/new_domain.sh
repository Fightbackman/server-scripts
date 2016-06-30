#!/bin/bash
configname=$1
newdomain=$2
web_service='nginx'
config_file=/etc/letsencrypt/configs/$1
if [ -f $config_file ]; then
 ./append_domain.sh $configname $2
 echo "file allready exists. Append domain to file."
 exit 0;
fi
echo "The Used config file is: $config_file"
echo "Creating new domainconfig."
sudo cp ../../configs/letsencrypt/letsencrypt-sample.ini $config_file;
sudo chown root:root $config_file;
sed "16s/$/ $newdomain/" $config_file > $config_file.tmp
mv $config_file.tmp $config_file
find /etc/letsencrypt/configs -type f -exec sudo chmod 644 {} \;;
./order_domain.sh $configname $newdomain $web_service;
echo "If you want to add additional domains to the new config use apend_domaind.sh"
exit 0;
