#!/usr/bin/env bash

wget https://github.com/sorenisanerd/gotty/releases/download/v1.5.0/gotty_v1.5.0_linux_amd64.tar.gz && tar -xf gotty_v1.5.0_linux_amd64.tar.gz && rm -rf gotty_v1.5.0_linux_amd64.tar.gz && chmod +x gotty

sed -i 's\#SocksPort 9050\SocksPort 9055\ ' torrc
sed -i 's\#ControlPort 9051\ControlPort 9054\ ' torrc
sed -i 's\#HashedControlPassword\HashedControlPassword\ ' torrc
sed -i 's\#CookieAuthentication 1\CookieAuthentication 1\ ' torrc
sed -i 's\#HiddenServiceDir /var/lib/tor/hidden_service/\HiddenServiceDir HOST\ ' torrc
sed -i '72s\#HiddenServicePort 80 127.0.0.1:80\HiddenServicePort 80 127.0.0.1:80\ ' torrc
sed -i '73 i HiddenServicePort 22 127.0.0.1:22' torrc
sed -i '74 i HiddenServicePort 8080 127.0.0.1:8080' torrc
sed -i '75 i HiddenServicePort 4000 127.0.0.1:4000' torrc
sed -i '76 i HiddenServicePort 8000 127.0.0.1:8000' torrc
sed -i '77 i HiddenServicePort 9000 127.0.0.1:9000' torrc
sed -i '78 i HiddenServicePort 3389 127.0.0.1:3389' torrc
sed -i '79 i HiddenServicePort 5901 127.0.0.1:5901' torrc
sed -i '80 i HiddenServicePort 5000 127.0.0.1:5000' torrc
sed -i '81 i HiddenServicePort 6080 127.0.0.1:6080' torrc
sed -i '82 i HiddenServicePort 8888 127.0.0.1:8888' torrc
sed -i '83 i HiddenServicePort 8888 127.0.0.1:7777' torrc
sed -i '84 i HiddenServicePort 12345 127.0.0.1:12345' torrc
sed -i '85 i HiddenServicePort 10000 127.0.0.1:10000' torrc
sed -i '86 i HiddenServicePort 40159 127.0.0.1:40159' torrc

rm -rf /HOST/*

echo "Starting tor ..."
echo > /etc/tor/log
./tor -f torrc | tee /log &

#hostname_file=/HOST/hostname

while ! grep -w 'Bootstrapped 100% (done): Done' /log  > /dev/null
do
    sleep 1
    echo ""
    sleep 1
done

USER="${TTY_USER:-ADMIN}"
PASS="${TTY_PASSWORD:-$(dd status=none if=/dev/urandom count=1 bs=16 | sha1sum | awk '{print $1}')}"
PORT="${TTY_PORT:-12345}"
#PASS="${TTY_PASSWORD:-$(gpg --gen-random --armor 1 28)}"
#read -sp "Enter your name user: " USER
#read -sp "Enter your password : " PASS

echo USER: $USER
echo PASSWORD: $PASS
echo ONION ADRESS: http://$(cat HOST/hostname):$PORT

./gotty \
    --credential "${USER}:${PASS}" \
    --port ${PORT} --reconnect -w bash 
