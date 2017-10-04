#!/bin/bash

# Wipe the team user in case we have already run
./wipe_team.sh
# Disable the firewall to allow packages, etc
./disable_firewall.sh
# User default stuff
./firefox.sh
./example_content.sh
# Install all desired packages
./packages.sh
# Network setup
./hosts.sh
./enable_firewall.sh
# Create fresh team user
./make_team.sh
