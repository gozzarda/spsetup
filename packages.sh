#!/bin/bash

# Update package list
# Add repositories
# Sublime Text
apt-get -y install apt-transport-https
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
# Set up minimal-ish gnome
apt-get -y install gnome-core
# Install packages
apt-get update && apt-get -y upgrade
apt-get -y install build-essential vim-gtk emacs sublime-text idle-python3.5 eclipse eclipse-cdt-valgrind gedit-plugins anjuta-extras geany-plugins clang-4.0
# Prevent iptables-persistent interactive setup
DEBIAN_FRONTEND=noninteractive apt-get -y install iptables-persistent
# Official Compiler Versions
apt-get -y install gcc=4:8.3.0-1
apt-get -y install openjdk-11-jdk=11.0.4+11-1~deb10u1 openjdk-11-jre=11.0.4+11-1~deb10u1
apt-get -y install python3=3.7.3-1
# Finalise package list
apt-get -y autoremove && apt-get -y autoclean
