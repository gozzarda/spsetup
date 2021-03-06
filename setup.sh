#!/bin/bash

# Wipe the team user in case we have already run
./wipe_team.sh
# Disable the firewall to allow packages, etc
./disable_firewall.sh
# Install all desired packages
./packages.sh
# User default stuff
./firefox.sh
# Printers EDIT AND UNCOMMENT IF YOU HAVE A PRINTER SETUP
# ./printers.sh
# Network setup
./hosts.sh
./enable_firewall.sh
# Create fresh team user
./make_team.sh
