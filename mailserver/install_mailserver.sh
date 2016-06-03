#!/bin/bash
USER=$1;
IP=$2
DOMAIN=$3;

if [ $(echo $@ | grep -o "complete") == 'complete' ]; then
  ARGS="letsencrypt nginx mysql-server postfix-bin postfix-conf dovecot-bin dovecot-conf roundcube-bin roundcube-conf phpmyadmin mail-db mailadmin mailmanager spamassassin-bin spamassassin-enable debian-bugfix";
else
  ARGS=$@;
fi;

# maybe use this and send crypted password on slack
# pwgen for generating safe passwords. (not necessary)
# ===============================
# ssh -t $USER@$IP '
# apt-get install pwgen;
# pwgen -s 20 1';
# ===============================

# letsencrypt
# ===================
if [ $(echo $ARGS | grep -o "letsencrypt") == 'letsencrypt' ]; then
  echo "letsencrypt";
  read;
  ../software/install_letsencrypt.sh $USER $IP;
fi;

# NGINX
# ===============================

if [ $(echo $ARGS | grep -o "nginx") == 'nginx' ]; then
  echo "NGINX";
  read;
  ../software/nginx.sh $USER $IP $DOMAIN;
fi;

# Mysql Server
# ===============================
if [ $(echo $ARGS | grep -o "mysql-server") == 'mysql-server' ]; then
  echo "MYSQL";
  read;
  ../software/mysql-server.sh $USER $IP;
fi;

# Postfix
# ===============================
if [ $(echo $ARGS | grep -o "postfix-bin") == 'postfix-bin' ]; then
  echo "POSTFIX";
  read;
  ../software/postfix.sh $USER $IP;
fi;

# spamassassin
# ============================
if [ $(echo $ARGS | grep -o "spamassassin-bin") == 'spamassassin-bin' ]; then
  echo "spamassassin";
  read;
  ssh -t $USER@$IP '
    sudo apt-get install spamassassin spamass-milter;';
fi;

# Dovecot
# ===============================
if [ $(echo $ARGS | grep -o "dovecot-bin") == 'dovecot-bin' ]; then
  echo "DOVECOT";
  read;
  ssh -t $USER@$IP '
  sudo apt-get install dovecot-mysql dovecot-pop3d dovecot-imapd dovecot-managesieved dovecot-lmtpd;';
fi;


# Roundcube
# ===============================
if [ $(echo $ARGS | grep -o "roundcube-bin") == 'roundcube-bin' ]; then
  echo "ROUNDCUBE this will harm your apache2!!!";
  read;
  ssh -t $USER@$IP '
    sudo su -c "echo \"deb http://http.debian.net/debian jessie-backports main\" > /etc/apt/sources.list.d/jessie-backports.list";
    sudo apt-get update;
    sudo apt-get install roundcube roundcube-plugins;
    sudo service apache2 stop;
    sudo apt-get purge apache2;
    sudo apt-get autoremove;';
fi;

# phpmyadmin
# ===============================
if [ $(echo $ARGS | grep -o "phpmyadmin") == 'phpmyadmin' ]; then
  echo "phpmyadmin";
  read;
  ssh -t $USER@$IP '
    sudo apt-get install phpmyadmin;
    sudo ln -s /usr/share/phpmyadmin/ /var/www/html/phpmyadmin;
  ';
fi;

# Mail database and user
# ===============================
if [ $(echo $ARGS | grep -o "mail-db") == 'mail-db' ]; then
  echo "Mail DATABASE";
  read;
  read -p 'Enter Password of mailuser: ' mypassword ;
  echo 'CREATE DATABASE mailserver;' > create.sql;
  echo "GRANT SELECT,INSERT,UPDATE,DELETE ON mailserver.* TO 'mailuser'@'127.0.0.1' IDENTIFIED BY '$mypassword';" >> create.sql;
  echo 'USE mailserver;' >> create.sql;
  echo 'CREATE TABLE IF NOT EXISTS `virtual_domains` (' >> create.sql;
  echo '`id` int(11) NOT NULL auto_increment,' >> create.sql;
  echo '`name` varchar(50) NOT NULL,' >> create.sql;
  echo 'PRIMARY KEY (`id`)' >> create.sql;
  echo ') ENGINE=InnoDB DEFAULT CHARSET=utf8;' >> create.sql;
  echo 'CREATE TABLE IF NOT EXISTS `virtual_users` (' >> create.sql;
  echo '`id` int(11) NOT NULL auto_increment,' >> create.sql;
  echo '`domain_id` int(11) NOT NULL,' >> create.sql;
  echo '`email` varchar(100) NOT NULL,' >> create.sql;
  echo '`password` varchar(150) NOT NULL,' >> create.sql;
  echo 'PRIMARY KEY (`id`),' >> create.sql;
  echo 'UNIQUE KEY `email` (`email`),' >> create.sql;
  echo 'FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE' >> create.sql;
  echo ') ENGINE=InnoDB DEFAULT CHARSET=utf8;' >> create.sql;
  echo 'CREATE TABLE IF NOT EXISTS `virtual_aliases` (' >> create.sql;
  echo '`id` int(11) NOT NULL auto_increment,' >> create.sql;
  echo '`domain_id` int(11) NOT NULL,' >> create.sql;
  echo '`source` varchar(100) NOT NULL,' >> create.sql;
  echo '`destination` varchar(100) NOT NULL,' >> create.sql;
  echo 'PRIMARY KEY (`id`),' >> create.sql;
  echo 'FOREIGN KEY (domain_id) REFERENCES virtual_domains(id) ON DELETE CASCADE' >> create.sql;
  echo ') ENGINE=InnoDB DEFAULT CHARSET=utf8;' >> create.sql;
  scp create.sql $USER@$IP:~/;
  ssh -t $USER@$IP "
    echo 'Password for Root user:';
    mysql -u root -p < ~/create.sql;
    rm ~/create.sql;";
  rm create.sql;
fi;
# dovecot pw -s SHA256-CRYPT to create secure password hashes

# Postfix Config
# ===============================
if [ $(echo $ARGS | grep -o "postfix-conf") == 'postfix-conf' ]; then
  echo "POSTFIX CONFIG";
  read;
  cp -r ../configs/postfix-conf .;
  #substitute passwords
  read -p 'Enter Password of mailuser: ' mypassword ;
  sed -i.bak "s/^\(password = \).*/\1$mypassword/" postfix-conf/mysql-virtual-mailbox-domains.cf;
  sed -i.bak "s/^\(password = \).*/\1$mypassword/" postfix-conf/mysql-virtual-mailbox-maps.cf;
  sed -i.bak "s/^\(password = \).*/\1$mypassword/" postfix-conf/mysql-virtual-alias-maps.cf;
  sed -i.bak "s/^\(password = \).*/\1$mypassword/" postfix-conf/mysql-email2email.cf;
  scp -r postfix-conf/ $USER@$IP:~/;
  rm -rf postfix-conf/;
  ssh -t $USER@$IP "
  sudo mv ~/postfix-conf/*.cf /etc/postfix/;
  rm -rf ~/postfix-conf/;
  sudo postconf virtual_mailbox_domains=mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf;
  sudo postconf virtual_mailbox_maps=mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf;
  sudo postconf virtual_alias_maps=mysql:/etc/postfix/mysql-virtual-alias-maps.cf,mysql:/etc/postfix/mysql-email2email.cf
  sudo chgrp postfix /etc/postfix/mysql-*.cf;
  sudo chmod u=rw,g=r,o= /etc/postfix/mysql-*.cf;";
fi;

# Dovecot Config
# ===============================
if [ $(echo $ARGS | grep -o "dovecot-conf") == 'dovecot-conf' ]; then
  echo "DOVECOT CONFIG";
  read;
  #create seperate user for security reasons
  ssh -t $USER@$IP '
    sudo groupadd -g 5000 vmail;
    sudo useradd -g vmail -u 5000 vmail -d /var/vmail -m;
    sudo chown -R vmail.vmail /var/vmail;';

  ssh -t $USER@$IP 'sudo rm -rf /etc/dovecot/*;';
  cp -r ../configs/dovecot-conf .;
  #substitute passwords
  read -p 'Enter Password of mailuser: ' mypassword ;
  sed -i.bak "s/^\(connect = host=127.0.0.1 dbname=mailserver user=mailuser password=\).*/\1$mypassword/" dovecot-conf/dovecot-sql.conf.ext;
  scp -r dovecot-conf/ $USER@$IP:~/;
  rm -rf dovecot-conf/;
  ssh -t $USER@$IP '
  sudo mv ~/dovecot-conf/* /etc/dovecot/;
  sudo rm -rf ~/dovecot-conf/
  sudo chown root:root /etc/dovecot/dovecot-sql.conf.ext;
  sudo chmod go= /etc/dovecot/dovecot-sql.conf.ext;
  sudo sievec /etc/dovecot/sieve-after/spam-to-folder.sieve;
  sudo service dovecot restart;
  sudo tail /var/log/mail.log;';
fi;

# Postfix LMTP communication
# ===============================
if [ $(echo $ARGS | grep -o "postfix-conf") == 'postfix-conf' ]; then
  echo "POSTFIX LMTP CONFIG";
  read;
  ssh -t $USER@$IP '
    sudo postconf virtual_transport=lmtp:unix:private/dovecot-lmtp;'
fi;

# Roundcube Config
# ===============================
if [ $(echo $ARGS | grep -o "roundcube-conf") == 'roundcube-conf' ]; then
  echo "ROUNDCUBE CONFIG";
  read;
  cp -r ../configs/roundcube-conf .;
  read -p 'Enter Password of mailuser: ' mypassword ;
  sed -i.bak -e "s/ChangeMe/$mypassword/g" roundcube-conf/plugins/password/config.inc.php;
  read -p 'Enter Database password for Roundcube: ' mypassword;
  sed -i.bak -e "s/Change me/$mypassword/g" roundcube-conf/debian-db.php;
  des_key=$(openssl rand -base64 24 | cut -c1-24);
  sed -i -e "s/CHANGE ME/$des_key/g" roundcube-conf/config.inc.php;
  scp -r roundcube-conf $USER@$IP:~/;
  rm -rf roundcube-conf;
  ssh -t $USER@$IP '
    sudo rm -rf /etc/roundcube/*;
    sudo cp -r ~/roundcube-conf/* /etc/roundcube/;
    rm -rf ~/roundcube-conf;
    sudo ln -s /usr/share/roundcube/ /var/www/html/roundcube;';
fi;

# Postfix user Dovecot for authentication for sending mailserver
# =================================================================
if [ $(echo $ARGS | grep -o "postfix-conf") == 'postfix-conf' ]; then
  echo "POSTFIX USES DOVECOT CONFIG";
  read;
  ssh -t $USER@$IP '
    sudo postconf smtpd_sasl_type=dovecot;
    sudo postconf smtpd_sasl_path=private/auth;
    sudo postconf smtpd_sasl_auth_enable=yes;';
  # Enable encryption
  ssh -t $USER@$IP '
    sudo postconf smtpd_tls_security_level=may;
    sudo postconf smtpd_tls_auth_only=yes;
    sudo postconf smtpd_tls_cert_file=/etc/letsencrypt/live/kevin-diehl.de/cert.pem;
    sudo postconf smtpd_tls_key_file=/etc/letsencrypt/live/kevin-diehl.de/privkey.pem;';
fi;

# Fix Debian bug #739738
# ============================
if [ $(echo $ARGS | grep -o "debian-bugfix") == 'debian-bugfix' ]; then
  echo "DEBIAN BUG FIX";
  read;
  ssh -t $USER@$IP '
    sudo sed -i -e "s/return if !defined $_[0];/return undef if !defined $_[0];/g" /usr/share/perl5/Mail/SpamAssassin/Util.pm;';
fi;

# Enable spamassassin
# ======================
if [ $(echo $ARGS | grep -o "spamassassin-enable") == 'spamassassin-enable' ]; then
  echo "ENABLE SPAMASSASSIN";
  read;

  ssh -t $USER@$IP "
  sudo postconf smtpd_milters=unix:/spamass/spamass.sock;
  sudo postconf milter_connect_macros='i j {daemon_name} v {if_name} _';
  sudo cp /etc/default/spamassassin ~/;
  sudo chown $USER ~/spamassassin";

  scp $USER@$IP:~/spamassassin . ;
  sed -i.bak 's/^\(OPTIONS=\).*/\1"--create-prefs --max-children 5 --helper-home-dir -x -u vmail"/' spamassassin;
  sed -i.bak "s/^\(CRON=\).*/\11/" spamassassin;
  scp spamassassin $USER@$IP:~;
  rm spamassassin*;
  ssh -t $USER@$IP '
  sudo mv ~/spamassassin /etc/default/spamassassin;
  sudo systemctl enable spamassassin;
  sudo adduser spamass-milter debian-spamd;
  sudo service spamassassin restart;
  sudo service spamass-milter restart;';
fi;

# Mailmanager USER to mysql
# ==========================
if [ $(echo $ARGS | grep -o "mailmanager") == 'mailmanager' ]; then
  echo "Mailmanager Mysql user";
  read;

  read -p "Define mailmanager password: " PASSWORD;
  echo "CREATE USER 'mailmanager'@'localhost' IDENTIFIED BY '$PASSWORD';" >query.sql;
  echo "GRANT ALL PRIVILEGES ON mailserver.* TO 'mailmanager'@'localhost';" >> query.sql;
  scp query.sql $USER@$IP:~;
  rm query.sql;
  echo "Mysql root password required:";
  ssh -t $USER@$IP 'mysql -u root -p < ~/query.sql; rm ~/query.sql;';
fi;

# AdminScripts to /opt/
# ==========================
if [ $(echo $ARGS | grep -o "mailadmin") == 'mailadmin' ]; then
  echo "AdminScripts to /opt/mailadmin"
  read;

  scp -r admin $IP:~;
  ssh -t $USER@$IP '
    sudo mkdir /opt/mailadmin;
    sudo mv admin/* /opt/mailadmin/;
    rm -rf admin;';
fi;

echo "fertig";
