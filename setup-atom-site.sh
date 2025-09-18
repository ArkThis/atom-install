#!/bin/bash

source config.sh

log "Finish AtoM installation (PHP symfony in $DIR_ATOM_SITE)..."
# ---------------------------------------
cd $DIR_ATOM_SITE
sudo -u $WEBSITE_USER php symfony tools:install
pause


log "Copy and enable atom-nginx site configuration..."
# ---------------------------------------
sudo cp $ATOM_CONF $ATOM_NGINX
sudo ln -sf $ATOM_NGINX /etc/nginx/sites-enabled/$THIS_ATOM
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
pause


log "Installing PHP FPM config..."
# ---------------------------------------
sudo cp -av $(basename $ATOM_PHPFPM) $ATOM_PHPFPM
pause

log "Start PHP-FPM..."
# ---------------------------------------
sudo systemctl enable $PHPFPM
sudo systemctl start $PHPFPM
sudo $PHPFPM_CMD --test

sudo rm /etc/php/8.3/fpm/pool.d/www.conf
sudo systemctl restart $PHPFPM
pause


log "Restart webservice..."
# ---------------------------------------
sudo systemctl enable nginx
sudo systemctl reload nginx
pause


