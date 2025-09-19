# Install Scripts for AtoM

This folder contains scripts and files needed to set up a fresh AtoM catalog
instance on a Linux machine.

Tested with these OS versions:

  - ubuntu-server 24.04.3


# Instructions

  * Edit `config.sh` to match your desires.
  * Run `./setup-atom.sh`.
  * Run `./setup-atom-ssl.sh` to configure "Let's Encrypt" SSL certificates (https)
    (This requires the hostname of the web-server to be world-reachable/resolvable per DNS)


# Structure

  * subfolder `files`:
    Contains config files required for the installation.
