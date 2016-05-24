#newdomain
This script add a new domain to an existing letsencrypt config file and renew the existing certificate
with the new domain added to it.
The config file will be edited ad the end of line 16 to add the new domain. A pattern search will be added.
#parameters:
$1 = configname
$2 = name of new domain
$3 = path to alternative config save folder. !doesn't work for now
$4 = name of web_service
