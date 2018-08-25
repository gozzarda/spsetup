#!/bin/bash


if [ -f /etc/hosts.bak ]; then
cp -a /etc/hosts.bak /etc/hosts
fi

cp -a /etc/hosts /etc/hosts.bak

cat << EOF_HOSTS >> /etc/hosts
192.254.188.84	contest.sppregional.org
EOF_HOSTS
