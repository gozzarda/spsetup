#!/bin/bash

# Update package list
apt-get update
# Add repositories
apt-get -y install software-properties-common apt-transport-https gnupg
# Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
# VS Code
wget -qO - https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
# Install packages
apt-get update && apt-get -y upgrade
# Set up minimal-ish gnome
apt-get -y install gnome-core
# Firefox
apt-get -y firefox
# Editors and such
apt-get -y install build-essential neovim vim-gtk emacs sublime-text code idle-python3.11 gedit-plugins geany-plugins
# Extra Compilers
apt-get -y install clang
# Official Compiler Versions (Ubuntu 22.04 defaults)
apt-get -y install gcc g++
apt-get -y install openjdk-11-jdk openjdk-11-jre
apt-get -y install pypy3
# Finalise package list
apt-get -y autoremove && apt-get -y autoclean
