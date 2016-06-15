#!/bin/bash
sudo openssl dhparam -out dhparams.pem 4096;
#~/postToSlack.sh "Diffie Hellman" "Key wurde erstellt";
sudo rm ~/diffie-hellman-background.sh;
sudo cp dhparams.pem /etc/nginx/
sudo service nginx restart;
