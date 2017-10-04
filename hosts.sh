#!/bin/bash


if [ -f /etc/hosts.bak ]; then
cp -a /etc/hosts.bak /etc/hosts
fi

cp -a /etc/hosts /etc/hosts.bak

cat << EOF_HOSTS >> /etc/hosts
132.181.7.114	domserver.cosc.canterbury.ac.nz
60.241.98.115	60-241-98-115.static.tpgi.com.au
EOF_HOSTS
