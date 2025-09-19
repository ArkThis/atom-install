#!/bin/bash
# ==============================================
# These are settings for the install of AtoM
# ==============================================

MYSELF="$0"                 # Useful to relate to paths relative to this config file.
THIS_ATOM="atom"            # Allows the string "atom" to be replaced where it
                            # makes sense to distinguish between instances.

SITE_NAME="$THIS_ATOM.allhau.av-rd.com"  # The FQDN of the Atom website to setup

ATOM="atom"
ATOM_DB="atom"
ATOM_DB_USER="atom"
ATOM_DB_PW="aTOmPASSword25"


# This version is tested to work:
PHP_VERSION="8.3"                       # This affects which packages are installed; fpm-service name, etc.

ATOM_TAR="atom-latest.tar.gz"
ATOM_WORKER="atom-worker.service"

APT="sudo apt"
# The calls add "-p" to allow (optional) password.
# Useful (=required) if you change "-u root" to "-u $ATOM_DB_USER":
MYSQL="sudo mysql -h localhost -u root"     # command to run mysql commands
WEBSITE_USER="www-data"
BECOME_WEB="sudo -u $WEBSITE_USER"

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
PKG_MEMCACHE="php-memcache memcached"

PKG_PHPFPM="php-fpm"
# NOTE: Most of the PHP packages /WITH/ $PHP_VERSION in their name, usually have a package name /WITHOUT/ the version.
# however, this allows to install a *specific* php version...
PKG_PHP="$PKG_PHPFPM $PKG_MEMCACHE php-common php$PHP_VERSION-common php$PHP_VERSION-cli php$PHP_VERSION-curl php-json php$PHP_VERSION-ldap php$PHP_VERSION-mysql php$PHP_VERSION-opcache php$PHP_VERSION-readline php$PHP_VERSION-xml php$PHP_VERSION-mbstring php$PHP_VERSION-xsl php$PHP_VERSION-zip php-apcu"

# Add up all packages for a single apt-install call:
PACKAGES="$PKG_SERVER $PKG_OTHER $PKG_PHP $PKG_ES $PKG_GEARMAN"



# --------------------------
# For website configuration
# --------------------------

ATOM_NGINX="/etc/nginx/sites-available/$ATOM"
ATOM_CONF="$ATOM.nginx"

ATOM_PHPFPM="/etc/php/$PHP_VERSION/fpm/pool.d/$ATOM.conf"
PHPFPM="php$PHP_VERSION-fpm"     # Yes, they're scrabmled, but quite-similar... (service)
PHPFPM_CMD="php-fpm$PHP_VERSION" # Yes, they're scrambled, but quite-similar... (command)

# --------------------------
# For AtoM upgrade (to newer version)
# --------------------------
ATOM_OLD="$HOME/install/atom"
ATOM_NEW="$DIR_ATOM_SITE"
ATOM_OLD_SQL="$HOME/install/atom-db_backup.sql.bz2"
ATOM_NEW_SYNC_FOLDERS="uploads downloads"

MYSQLDUMP="sudo mysqldump"


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

echo "Loaded config: $MYSELF"
