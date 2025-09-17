#!/bin/bash

THIS_ATOM="atom"

ATOM_NGINX="/etc/nginx/sites-available/$THIS_ATOM"
ATOM_CONF="$THIS_ATOM.nginx"

DIR_NGINX_SITES="/usr/share/nginx"
DIR_ATOM_SITE="$DIR_NGINX_SITES/$THIS_ATOM"
WEBSITE_USER="www-data"

cd $DIR_ATOM_SITE
sudo -u $WEBSITE_USER php symfony tools:install

sudo cp $ATOM_CONF $ATOM_NGINX
sudo ln -sf $ATOM_NGINX /etc/nginx/sites-enabled/$THIS_ATOM
sudo rm /etc/nginx/sites-enabled/default

# Start PHP-FPM

PHPFPM="php8.3-fpm"     # Yes, they're scrabmled, but quite-similar...
PHPFPM_CMD="php-fpm8.3" # Yes, they're scrambled, but quite-similar...
sudo systemctl enable $PHPFPM
sudo systemctl start $PHPFPM
sudo $PHPFPM_CMD --test

sudo rm /etc/php/8.3/fpm/pool.d/www.conf
sudo systemctl restart $PHPFPM

# Restart webservice:
sudo systemctl enable nginx
sudo systemctl reload nginx

