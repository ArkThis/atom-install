#!/bin/bash
#@date: 2025-09-17

source config.sh

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
    eval $PAUSE
fi

ES_APT_LIST=/etc/apt/sources.list.d/elastic-6.x.list
if [ ! -s "$ES_APT_LIST" ]; then
    echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/oss-6.x/apt stable main" | sudo tee -a $ES_APT_LIST
    eval $PAUSE
fi


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
./setup-atom-site.sh

