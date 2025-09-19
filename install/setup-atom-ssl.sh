#!/bin/bash

source config.sh

if [ -z "$1" ]; then
    echo "No site name given (eg atom.example.com)"
    echo "Using default: $SITE_NAME"
else
    SITE_NAME="$1"
fi

# This must be run for each atom site individually, as the server_name / DNS /
# URL will differ.

log "Enabling SSL certificate..."
# ---------------------------------------
# From:
# https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-20-04

$APT install certbot python3-certbot-nginx
grep -Hn "server_name" $ATOM_NGINX

echo ""
echo "Please set 'server_name' in that config file to match the site-name"
echo "'$SITE_NAME' of your server!"
echo "THEN continue."
echo ""

pause

# Yes, I know we just did that, but I'd rather not combine too many steps to
# each other to debug if there's an issue.
log "Restarting nginx..."
# ---------------------------------------
sudo nginx -t
sudo systemctl reload nginx

sudo certbot --nginx -d $SITE_NAME
# sudo nginx -T | grep ssl_
