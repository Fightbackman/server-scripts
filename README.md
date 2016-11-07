# server-scripts
Scripts from our everyday serverwork.
All of this scripts are published under the GPLv3 if not other specified.
Warning. We expect systemd ruunning on your system, if you want to use these scripts.
All scripts are tested with Debian Jessie.
Support for init.d maybe come with the future or if you help us to improve our scripts for using that.

# List of current stored scripts:
### Format: Scriptname: Short discription

## Backup

### backup.py
This scripts fetches every yaml file in the script directory
and processes it. It will check hashes with the calcHash.py script in
General-purpose for everything which is defined in the target specification. (excluding everything in "exclude")

## Configs
Every config has to be modified before usage. Either by the mailscript or manually

### Dovecot-conf
This contains the config of dovecot.

### Postfix-conf
This directory contains the config of Postfix.

### Rouncube-conf
This directory contains the config of Roundcube Webmailer.

## General-purpose

### Basic_security.sh
Installs iptables and fail2ban. Deactivate passwort login for root or all users.
### calcHash.py
This works as a library for calculating Hashes for files or directories.
### getGitPriv.sh
This scripts allows you to download files from a private Github repository.(needs auth token)
### check_init.sh (TODO)
Checks if init.d oder systemd is used
### diffie-hellman.sh
Creates an diffie-hellman key for nginx
###

## hetzner(TODO)
This folder contains scripts to work with the domain registration robot and the server robot from the server hosting company "Hetzner"

## letsencrypt
The letsencrypt scripts are splitted into two parts. One part is used to add new domains to an existing config. This one is called addnew. The other one is called autorenew and is used to automaticly renew certificates if they have less then 30 days left.

## mailserver
The mailserver scripts deploy a full working mail server with dovecot and postfix.
Mysql is used as user backend and gets managed by phpmyadmin running on an nginx.
As fronted Roundcube will be used. The mailserver automatically receives certificates from letsencrypt. Each compenen could be selected like you want. There are also management scripts to administrate the mailserver.

## software
This category bundles a bunch of single scripts to install specific software needed from other scripts or is just a nice to have.
- docker
- fail2ban
- gitlab
- letsencrypt
- iptables
- Mysql
- nginx
- owncloud
- Postfix
- python
- teamspeak
