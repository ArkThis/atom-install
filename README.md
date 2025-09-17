# atom-install

Scripted install routines for AtoM (Artefactual)

# Tested on ubuntu-server 24.04.3

These scripts are "works-for-me", and on my homework-list to be converted to ansible. And before I do that, I'd rather search the web if anyone has already done and published that, so I don't have to. :wink:

# Usage

# Structure

The installation is broken down into those components (=scripts):

  - setup-atom.sh
  - setup-atom-db.sh
  - setup-atom-site.sh

The first script calls the other 2 (db and site) automatically when it's their turn.

The installation routines are basically a script-version of the [official installation instructions](https://www.accesstomemory.org/en/docs/2.9/admin-manual/installation/ubuntu/#installation-ubuntu).

Good luck!
