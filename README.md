# server-scripts
Scripts from our everyday serverwork.
Warning. We expect systemd ruunning on your system, if you want to use these scripts.
All scripts are tested with Debian Jessie.
Support for init.d maybe come with the future or if you help us to improve our scripts for using that.

# List of current storred scripts:
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

###

## letsencrypt

## mailserver

## software
