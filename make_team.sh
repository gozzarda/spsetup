#!/bin/bash

source ./spsetup.conf

id -u $user
if [ $? == 1 ]; then
useradd $user -s /bin/bash -m -c "$name,,,"
passwd $user << EOF_PASSWD
$pass
$pass
EOF_PASSWD
cat << EOF_LIGHTDM > /etc/lightdm/lightdm.conf
[Seat:*]
autologin-user=$user
EOF_LIGHTDM
fi
