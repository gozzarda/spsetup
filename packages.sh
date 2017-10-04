#!/bin/bash

# Update package list
# Add repositories
add-apt-repository -y ppa:webupd8team/sublime-text-3
# sed -i 's/ main restricted/ main universe multiverse restricted/g' /etc/apt/sources.list
# Remove packages
apt-get -y purge aisleriot brasero cheese empathy gnome-mahjongg gnome-mines gnome-software gnome-sudoku gparted landscape-client-ui-install libreoffice-core remmina rhythmbox shotwell simple-scan software-center thunderbird totem transmission-gtk ubiquity unity-control-center-signon unity-webapps-service
# Install packages
apt-get update && apt-get -y upgrade
apt-get -y install build-essential vim-gtk emacs sublime-text-installer idle-python3.5 eclipse eclipse-cdt-valgrind gedit-developer-plugins gedit-plugins anjuta-extras geany-plugins clang-4.0
# Prevent iptables-persistent interactive setup
DEBIAN_FRONTEND=noninteractive apt-get -y install iptables-persistent
# Official Compiler Versions
apt-get -y install gcc-5=5.4.0-6ubuntu1~16.04.4
apt-get -y install openjdk-8-jdk=8u131-b11-2ubuntu1.16.04.3 openjdk-8-jre=8u131-b11-2ubuntu1.16.04.3
apt-get -y python3.5=3.5.2-2ubuntu0~16.04.3
# Finalise package list
apt-get -y autoremove && apt-get -y autoclean
