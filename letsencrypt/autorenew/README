#autorenew
Dieses Skript erneuert automatisch bestehende Zertifikate, wenn diese eine Restlaufzeit von weniger als 30 Tagen haben.
Dazu werden Konfigurationsdateien nach dem folgenden für letsencrypt typischen Format verwendet:

```

# This is an example of the kind of things you can do in a configuration file.
# All flags used by the client can be configured here. Run Let's Encrypt with
# "--help" to learn more about the available options.

# Use a 4096 bit RSA key instead of 2048
rsa-key-size = 4096

# Always use the staging/testing server
#server = https://acme-staging.api.letsencrypt.org/directory

# Uncomment and update to register with the specified e-mail address
 email = webmaster@domain.xx

# Uncomment and update to generate certificates for the specified
# domains.
 domains = xxxx.xx, www.xxxx.xx, xx.xxxx.xx

# Uncomment to use a text interface instead of ncurses
 text = True

# Uncomment to use the standalone authenticator on port 443
# authenticator = standalone
# standalone-supported-challenges = tls-sni-01

# Uncomment to use the webroot authenticator. Replace webroot-path with the
# path to the public_html / webroot folder being served by your web server.
# authenticator = webroot
# webroot-path = /home/nginx/sites/letsencrypt/

```

Die Dateien sollten hierbei in der Regel den Namen der Hauptdomain des Zertifikats tragen und haben optional die Endung .ini
Der webroot-path wird im autorenew script definiert. Zu beachten ist hier, dass alle domains sich ein webroot für letsencrypt teilen.
Genaueres kann man hier der letsencrypt bzw der certbot Dokumentation zu entnehmen.
