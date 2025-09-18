#!/bin/bash
# ==============================================
# These are settings for the install of AtoM
# ==============================================

THIS_ATOM="atom-edit"       # Allows the string "atom" to be replaced where it
                            # makes sense to distinguish between instances.

SITE_NAME="$THIS_ATOM.example.com"  # The FQDN of the Atom website to setup

ATOM="atom"
ATOM_DB="atom"
ATOM_DB_USER="atom"
ATOM_DB_PW="aTOmPASSword25"

ATOM_TAR="atom-latest.tar.gz"
ATOM_WORKER="atom-worker.service"

APT="sudo apt"
WEBSITE_USER="www-data"

DIR_NGINX_SITES="/usr/share/nginx"
DIR_ATOM_SITE="$DIR_NGINX_SITES/$ATOM"


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
# For website configuration
# --------------------------

ATOM_NGINX="/etc/nginx/sites-available/$THIS_ATOM"
ATOM_CONF="atom.nginx"

ATOM_PHPFPM="/etc/php/8.3/fpm/pool.d/atom.conf"
PHPFPM="php8.3-fpm"     # Yes, they're scrabmled, but quite-similar...
PHPFPM_CMD="php-fpm8.3" # Yes, they're scrambled, but quite-similar...


# --------------------------
# General functions
# --------------------------

PAUSE="read -p 'press return...'"
function pause
{
    read -p 'press return...'
}

function log
{
    MSG="$1"
    echo ""
    echo ""
    echo "  $MSG"
    echo "========================================"
    echo ""
}

function run
{
    CMD="$1"
    echo "$CMD"
    eval "$CMD"
}

