#!/bin/bash

# Install and enable nftables
apt-get update
apt-get install nftables
systemctl enable nftables.service
