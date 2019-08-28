#!/bin/bash

# Install nftables if we don't have it
if ! [ -x "$(command -v nft)"  ]; then ./get_nft.sh; fi
# Load ruleset from file
nft -f firewall.nft
