#!/bin/bash

source ./spsetup.conf

if [ -d $arch ]; then
rm -rf $arch/*
fi
