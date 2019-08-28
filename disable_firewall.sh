#!/bin/bash

# Install nftables if we don't have it
if ! [ -x "$(command -v nft)"  ]; then ./get_nft.sh; fi
# Clear the firewall ruleset
nft flush ruleset
