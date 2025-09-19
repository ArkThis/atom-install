#!/bin/bash
#@date: 2025-09-17
#@author: Peter B. (p.bubestinger@ArkThis.com)
#Instructions based on:
#https://www.accesstomemory.org/en/docs/2.9/admin-manual/installation/upgrading/

MYDIR=$(dirname "$0")            # path of this script
RSYNC="sudo rsync -avP --delete"
source "$MYDIR/../config.sh"     # Load variables/functions


log "Copying existing AtoM contents ($ATOM_NEW_SYNC_FOLDERS)..."
# --------------------------

# Iterate through each sync-folder and copy its contents to the new installation:
for FOLDER in $ATOM_NEW_SYNC_FOLDERS; do
    #continue # Enable to DEBUG lower parts of the script.

    # sanity checks:
    if [ ! -d "$ATOM_OLD/$FOLDER" ]; then
        echo "ERROR: AtoM uploads folder not found: '$ATOM_OLD/$FOLDER'"
        exit 1
    fi

    # The slash "/" at the end of the folders is important:
    # (without it, the 'uploads'-folder (not its contents) would be copied.
    log "Copying '$ATOM_OLD/$FOLDER' to '$ATOM_NEW'..."
    # --------------------------
    $RSYNC $ATOM_OLD/$FOLDER/ $ATOM_NEW/$FOLDER/

    log "Applying ownership of '$FOLDER' to '$WEBSITE_USER:$WEBSITE_USER'..."
    # --------------------------
    sudo chown -R $WEBSITE_USER:$WEBSITE_USER $ATOM_NEW/$FOLDER
done

pause


log "If backup exists: import - or otherwise: creating one..."

if [ ! -s $ATOM_OLD_SQL ]; then
    log "NO existing SQL backup file found."
    log "Dumping DB backup of existing AtoM to '$ATOM_OLD_SQL'..."
    # --------------------------
    pause
    $MYSQLDUMP -u $ATOM_DB_USER -p $ATOM_DB | bzip2 > $ATOM_OLD_SQL
    echo "Done ($?)."
    echo "This file will be used to import into the new installation when restarting the script."
    pause
fi

if [ -s $ATOM_OLD_SQL ]; then
    log "Importing backup from '$ATOM_OLD_SQL' into '$ATOM_DB' database..."
    # --------------------------
    pause
    bzip2 -dc $ATOM_OLD_SQL | $MYSQL -p $ATOM_DB
    echo "Done ($?)."
    pause
fi
