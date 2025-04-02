#!/bin/bash

# Prevent prompts about restarting services
export DEBIAN_FRONTEND=noninteractive

# Update package list
apt-get update

# Add repositories
apt-get -y install software-properties-common apt-transport-https gnupg wget ca-certificates
# Sublime Text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
# VS Code
wget -qO - https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg
# Firefox (Disable Snap, use Mozilla PPA)
cat << EOF_FIREFOX_NOSNAP | tee /etc/apt/preferences.d/firefox-no-snap.pref
Package: firefox*
Pin: release o=Ubuntu*
Pin-Priority: -1
EOF_FIREFOX_NOSNAP
sudo add-apt-repository -y ppa:mozillateam/ppa

# Install packages
apt-get update && apt-get -y upgrade
# Set up minimal-ish gnome (Chromium to prevent Firefox Snap)
apt-get -y install chromium-browser gnome-core
# Firefox
apt-get -y install firefox
# Editors and such
apt-get -y install build-essential neovim vim-gtk3 emacs sublime-text code idle-python3.12 gedit-plugins geany-plugins
# Extra Compilers
apt-get -y install clang
# (NOT) Official Compiler Versions (should be Ubuntu 22.04 defaults but not available)
apt-get -y install gcc g++
apt-get -y install openjdk-11-jdk openjdk-11-jre
apt-get -y install pypy3
# Finalise package list
apt-get -y autoremove && apt-get -y autoclean
