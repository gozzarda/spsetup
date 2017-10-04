#!/bin/bash

source ./spsetup.conf

id -u $user
if [ $? != 1 ]; then
pkill -KILL -u $user
if [ -d $arch ]; then
file="$arch/$(date -u +"%Y-%m-%dT%H:%M:%SZ").tar.gz"
tar -zcf $file /home/$user
chmod o-rwx $file
fi
find / -user $user -exec rm -rf {} \;
deluser --remove-home $user
delgroup $user
rm -f /etc/lightdm/lightdm.conf
fi
