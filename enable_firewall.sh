#!/bin/bash

# Install nftables if we don't have it
if ! [ -x "$(command -v nft)"  ]; then ./get_nft.sh; fi
# Reload ruleset from file and save
nft flush ruleset
nft -f firewall.nft
nft list ruleset > /etc/nftables.conf
