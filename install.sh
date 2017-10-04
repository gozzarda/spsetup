#!/bin/bash

rm -rf /usr/share/spsetup /usr/bin/spsetup
mkdir /usr/share/spsetup
cp -r ./* /usr/share/spsetup
ln -s /usr/share/spsetup/spsetup.sh /usr/bin/spsetup
