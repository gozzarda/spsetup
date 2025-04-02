#!/bin/bash

# Install nftables if we don't have it
if ! [ -x "$(command -v /usr/sbin/nft)"  ]; then ./get_nft.sh; fi
# Reload ruleset from file and save
/usr/sbin/nft flush ruleset
/usr/sbin/nft -f firewall.nft
/usr/sbin/nft list ruleset > /etc/nftables.conf
