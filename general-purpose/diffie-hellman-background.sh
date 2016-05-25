#!/bin/bash
openssl dhparam -out dhparams.pem 4096;
#~/postToSlack.sh "Diffie Hellman" "Key wurde erstellt";
rm ~/diffie-hellman-background.sh;
cp dhparams.pem /etc/nginx/
service nginx restart;
