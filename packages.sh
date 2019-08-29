#!/bin/bash

# Update package list
apt-get update
# Add repositories
apt-get -y install software-properties-common apt-transport-https gnupg
# Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
# Atom
wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list
# VS Code
curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
# Install packages
apt-get update && apt-get -y upgrade
# Set up minimal-ish gnome
apt-get -y install gnome-core
# Editors and such
apt-get -y install build-essential vim-gtk emacs sublime-text atom code idle-python3.7 gedit-plugins anjuta-extras geany-plugins
# Extra Compilers
apt-get -y install clang
# Official Compiler Versions
apt-get -y install gcc=4:8.3.0-1 g++=4:8.3.0-1
apt-get -y install openjdk-11-jdk=11.0.4+11-1~deb10u1 openjdk-11-jre=11.0.4+11-1~deb10u1
apt-get -y install python3=3.7.3-1
# Finalise package list
apt-get -y autoremove && apt-get -y autoclean
