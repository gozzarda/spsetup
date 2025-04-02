#!/bin/bash


if [ -f /etc/hosts.bak ]; then
cp -a /etc/hosts.bak /etc/hosts
fi

cp -a /etc/hosts /etc/hosts.bak

cat << EOF_HOSTS >> /etc/hosts
170.64.169.12   sppcontests.org
170.64.253.143	contest.sppcontests.org
EOF_HOSTS
