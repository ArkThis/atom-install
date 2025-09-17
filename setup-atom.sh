#!/bin/bash
#@date: 2025-09-17

THIS_ATOM="atom"            # Allows the string "atom" to be replaced "as good as possible". USE WITH CAUTION! May fail with existing default config.

ATOM_TAR="atom-latest.tar.gz"
ATOM_WORKER="atom-worker.service"
ATOM_PHPFPM="/etc/php/8.3/fpm/pool.d/atom.conf"

APT="sudo apt"
WEBSITE_USER="www-data"

DIR_NGINX_SITES="/usr/share/nginx"
DIR_ATOM_SITE="$DIR_NGINX_SITES/$THIS_ATOM"

PAUSE="read -p 'press any key to continue...'"

# ---------------------------------------
# Required Packages
# ---------------------------------------
PKG_SERVER="mysql-server nginx"
PKG_OTHER="openjdk-11-jre-headless apt-transport-https software-properties-common"
PKG_OTHER2="fop libsaxon-java"
PKG_MEDIA="imagemagick ghostscript poppler-utils ffmpeg"
PKG_GEARMAN="gearman-job-server"
PKG_ELASTISEARCH="elasticsearch-oss"
PKG_MEMCACHE="php-memcache"
PKG_PHPFPM="php-fpm"
PKG_PHP="$PKG_PHPFPM $PKG_MEMCACHE php-common php8.3-common php8.3-cli php8.3-curl php-json php8.3-ldap php8.3-mysql php8.3-opcache php8.3-readline php8.3-xml php8.3-mbstring php8.3-xsl php8.3-zip php-apcu"

# Add up all packages for a single apt-install call:
PACKAGES="$PKG_SERVER $PKG_OTHER $PKG_PHP $PKG_ES $PKG_GEARMAN"
# --------------------------

eval $PAUSE

# --------------------------
echo ""
echo "Download and install the public signing key used in the ElasticSearch repository..."
echo ""
# --------------------------

ES_KEYRING="/usr/share/keyrings/elasticsearch-keyring.gpg"
# Only fetch the keyring if it ain't exist already:
if [ ! -s "$ES_KEYRING" ]; then
    wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o $ES_KEYRING
fi

ES_APT_LIST=/etc/apt/sources.list.d/elastic-6.x.list
if [ ! -s "$ES_APT_LIST" ]; then
    echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/oss-6.x/apt stable main" | sudo tee -a $ES_APT_LIST
fi

eval $PAUSE


# --------------------------
echo ""
echo "Install required packages..."
echo ""
# --------------------------
$APT update
$APT install --no-install-recommends $PACKAGES

# This must be done /AFTER/ installing Java:
$APT install $PKG_ELASTISEARCH

eval $PAUSE


# --------------------------
echo ""
echo "Enabling ElasticSearch..."
echo ""
# --------------------------
sudo systemctl enable elasticsearch
sudo systemctl start elasticsearch

eval $PAUSE


# --------------------
echo ""
echo "Install from tarball"
echo ""
# --------------------

# Clean and create website folder:
sudo rm -rf $DIR_ATOM_SITE
sudo mkdir $DIR_ATOM_SITE
sudo chown -R $WEBSITE_USER:$WEBSITE_USER $DIR_ATOM_SITE

if [ ! -s "$ATOM_TAR" ]; then
    echo "Downloading tarball..."
    wget https://storage.accesstomemory.org/releases/$ATOM_TAR
fi

eval $PAUSE

echo "Unpacking AtoM to '$DIR_ATOM_SITE'..."
sudo -u $WEBSITE_USER tar -xzvf $ATOM_TAR -C $DIR_ATOM_SITE --strip 1

eval $PAUSE

# Setup the database:
./setup-atom-db.sh


# --------------------
echo ""
echo "Installing AtoM worker..."
echo ""
# --------------------
sudo cp -av ./$ATOM_WORKER /usr/lib/systemd/system/$ATOM_WORKER
sudo systemctl daemon-reload
sudo systemctl enable atom-worker
sudo systemctl start atom-worker

echo $PAUSE

# --------------------
echo ""
echo "Installing PHP FPM config..."
echo ""
# --------------------

sudo cp -av $(basename $ATOM_PHPFPM) $ATOM_PHPFPM

echo $PAUSE

echo "-=. READY to install AtoM .=-"
echo ""
echo "Run the following commands:"
echo ""
echo "cd $DIR_ATOM_SITE"
echo "sudo -u $WEBSITE_USER php symfony tools:install"
echo ""
echo ""
