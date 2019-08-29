#!/bin/bash

# Install and enable nftables
apt-get update
apt-get -y install nftables
systemctl enable nftables.service
