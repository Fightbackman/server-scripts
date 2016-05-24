#!/bin/bash
IP=$1;
USER=root;

# pwgen for generating safe passwords. (not necessary)
# ===============================
# ssh -t $USER@$IP '
# apt-get install pwgen;
# pwgen -s 20 1';
# ===============================

echo "letsencrypt";
read;

# letsencrypt
# ===================

../../../software/install_letsencrypt.sh $IP $USER;

echo "NGINX";
read;

# Apache oder anderen Web server aufsetzen
# ===============================
./nginx.sh $IP $USER;

echo "MYSQL";
read;

# Mysql Server
# ===============================
ssh -t $USER@$IP '
apt-get update;
apt-get install mysql-server;';

echo "POSTFIX";
read;

# Postfix and SpamAssassin
# ===============================
ssh -t $USER@$IP '
apt-get install postfix postfix-mysql;
apt-get --purge remove "exim4*";
apt-get install spamassassin spamass-milter;
apt-get install swaks;';

echo "DOVECOT";
read;

# Dovecot
# ===============================
ssh -t $USER@$IP '
apt-get install dovecot-mysql dovecot-pop3d dovecot-imapd dovecot-managesieved dovecot-lmtpd;';

echo "ROUNDCUBE";
read;

# Roundcube
# ===============================
ssh -t $USER@$IP '
echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list;
apt-get update;
apt-get install roundcube roundcube-plugins;
service apache2 stop;
apt-get purge apache2;
apt-get autoremove;';

echo "PREPARE DATABASE";
read;

# Prepare Database
# ===============================
 ssh -t $USER@$IP '
 apt-get install phpmyadmin;
 ln -s /usr/share/phpmyadmin/ /var/www/html/phpmyadmin;
';

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
mysql -u root -p < ~/create.sql;
rm ~/create.sql;
"
rm create.sql;

# dovecot pw -s SHA256-CRYPT to create secure password hashes

echo "POSTFIX CONFIG";
read;

# Postfix Config
# ===============================
git clone git@gitlab.shrlck.de:team/postfix-conf.git;
#substitute passwords
read -p 'Enter Password of mailuser: ' mypassword ;
sed -i.bak "s/^\(password = \).*/\1$mypassword/" postfix-conf/mysql-virtual-mailbox-domains.cf;
sed -i.bak "s/^\(password = \).*/\1$mypassword/" postfix-conf/mysql-virtual-mailbox-maps.cf;
sed -i.bak "s/^\(password = \).*/\1$mypassword/" postfix-conf/mysql-virtual-alias-maps.cf;
sed -i.bak "s/^\(password = \).*/\1$mypassword/" postfix-conf/mysql-email2email.cf;
scp postfix-conf/*.cf $USER@$IP:/etc/postfix/;
rm -rf postfix-conf/;
ssh -t $USER@$IP "
postconf virtual_mailbox_domains=mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf;
postconf virtual_mailbox_maps=mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf;
postconf virtual_alias_maps=mysql:/etc/postfix/mysql-virtual-alias-maps.cf,mysql:/etc/postfix/mysql-email2email.cf
chgrp postfix /etc/postfix/mysql-*.cf;
chmod u=rw,g=r,o= /etc/postfix/mysql-*.cf;";

echo "DOVECOT CONFIG";
read;

# Dovecot Config
# ===============================
#create seperate user for security reasons
ssh -t $USER@$IP '
groupadd -g 5000 vmail;
useradd -g vmail -u 5000 vmail -d /var/vmail -m;
chown -R vmail.vmail /var/vmail;
'

ssh -t $USER@$IP 'rm -rf /etc/dovecot/*;';
git clone git@gitlab.shrlck.de:team/dovecot-conf.git;
#substitute passwords
read -p 'Enter Password of mailuser: ' mypassword ;
sed -i.bak "s/^\(connect = host=127.0.0.1 dbname=mailserver user=mailuser password=\).*/\1$mypassword/" dovecot-conf/dovecot-sql.conf.ext;
scp -r dovecot-conf/* $USER@$IP:/etc/dovecot/;
rm -rf dovecot-conf/;
ssh -t $USER@$IP '
chown root:root /etc/dovecot/dovecot-sql.conf.ext;
chmod go= /etc/dovecot/dovecot-sql.conf.ext;
service dovecot restart;
cat /var/log/mail.log;';


echo "POSTFIX LMTP CONFIG";
read;

# Postfix LMTP communication
# ===============================
ssh -t $USER@$IP '
postconf virtual_transport=lmtp:unix:private/dovecot-lmtp;'

echo "ROUNDCUBE CONFIG";
read;

#Roundcube Config
# ===============================
git clone git@gitlab.shrlck.de:team/roundcube-conf.git;
read -p 'Enter Password of mailuser: ' mypassword ;
sed -i -e "s/ChangeMe/$mypassword/g" roundcube-conf/plugins/password/config.inc.php;
scp -r roundcube-conf/* $USER@$IP:/etc/roundcube/;
rm -rf roundcube-conf;

ssh -t $USER@$IP '
ln -s /usr/share/roundcube/ /var/www/html/roundcube;';

echo "POSTFIX USES DOVECOT CONFIG";
read;

# Postfix user Dovecot for authentication for sending mailserver
# =================================================================

ssh -t $USER@$IP '
postconf smtpd_sasl_type=dovecot;
postconf smtpd_sasl_path=private/auth;
postconf smtpd_sasl_auth_enable=yes;
'
# Enable encryption
ssh -t $USER@$IP '
postconf smtpd_tls_security_level=may
postconf smtpd_tls_auth_only=yes
postconf smtpd_tls_cert_file=/etc/letsencrypt/live/kevin-diehl.de/cert.pem
postconf smtpd_tls_key_file=/etc/letsencrypt/live/kevin-diehl.de/privkey.pem
'

echo "DEBIAN BUG FIX";
read;

# Fix Debian bug #739738
# ============================
ssh -t $USER@$IP '
sed -i -e "s/return if !defined $_[0];/return undef if !defined $_[0];/g" /usr/share/perl5/Mail/SpamAssassin/Util.pm;
';

echo "ENABLE SPAMASSASSIN";
read;

# Enable spamassassin
# ======================
ssh -t $USER@$IP '
postconf smtpd_milters=unix:/spamass/spamass.sock;
postconf milter_connect_macros="i j {daemon_name} v {if_name} _";
';
scp $USER@$IP:/etc/default/spamassassin . ;
sed -i.bak 's/^\(OPTIONS=\).*/\1"--create-prefs --max-children 5 --helper-home-dir -x -u vmail"/' spamassassin;
sed -i.bak "s/^\(CRON=\).*/\11/" spamassassin;
scp spamassassin $USER@$IP:/etc/default/spamassassin;
rm spamassassin*;
ssh -t $USER@$IP '
systemctl enable spamassassin;
adduser spamass-milter debian-spamd;
service spamassassin restart;
service spamass-milter restart;';

# Mailmanager USER to mysql
# ==========================
read -p "Define mailmanager password: " PASSWORD;
echo "CREATE USER 'mailmanager'@'localhost' IDENTIFIED BY '$PASSWORD';" >query.sql;
echo "GRANT ALL PRIVILEGES ON mailserver.* TO 'mailmanager'@'localhost';" >> query.sql;
scp query.sql $USER@$IP:~;
rm query.sql;
ssh -t $USER@$IP 'mysql -u root -p < ~/query.sql; rm ~/query.sql;';
