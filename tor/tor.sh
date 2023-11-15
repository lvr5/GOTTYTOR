#!/usr/bin/env bash

cd "$self" && sed -i 's\#SocksPort 9050\SocksPort 9055\ ' torrc
cd "$self" && sed -i 's\#ControlPort 9051\ControlPort 9054\ ' torrc
cd "$self" && sed -i 's\#HashedControlPassword\HashedControlPassword\ ' torrc
cd "$self" && sed -i 's\#CookieAuthentication 1\CookieAuthentication 1\ ' torrc
cd "$self" && sed -i 's\#HiddenServiceDir /var/lib/tor/hidden_service/\HiddenServiceDir HOST\ ' torrc
cd "$self" && sed -i '72s\#HiddenServicePort 80 127.0.0.1:80\HiddenServicePort 80 127.0.0.1:80\ ' torrc
cd "$self" && sed -i '73 i HiddenServicePort 22 127.0.0.1:22' torrc
cd "$self" && sed -i '74 i HiddenServicePort 8080 127.0.0.1:8080' torrc
cd "$self" && sed -i '75 i HiddenServicePort 4000 127.0.0.1:4000' torrc
cd "$self" && sed -i '76 i HiddenServicePort 8000 127.0.0.1:8000' torrc
cd "$self" && sed -i '77 i HiddenServicePort 9000 127.0.0.1:9000' torrc
cd "$self" && sed -i '78 i HiddenServicePort 3389 127.0.0.1:3389' torrc
cd "$self" && sed -i '79 i HiddenServicePort 5901 127.0.0.1:5901' torrc
cd "$self" && sed -i '80 i HiddenServicePort 5000 127.0.0.1:5000' torrc
cd "$self" && sed -i '81 i HiddenServicePort 6080 127.0.0.1:6080' torrc
cd "$self" && sed -i '82 i HiddenServicePort 8888 127.0.0.1:8888' torrc
cd "$self" && sed -i '83 i HiddenServicePort 8888 127.0.0.1:7777' torrc
cd "$self" && sed -i '84 i HiddenServicePort 12345 127.0.0.1:12345' torrc
cd "$self" && sed -i '85 i HiddenServicePort 10000 127.0.0.1:10000' torrc
cd "$self" && sed -i '86 i HiddenServicePort 40159 127.0.0.1:40159' torrc

set -e
set +x

self="$(cd "$(dirname "$BASH_SOURCE[0]")" && pwd)"
cd "$self"

ly() {
    echo -e "\e[93m$@\e[0m"
}

if [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
    {
        echo "$0 [-h|--help] [-e]"
        echo
        echo "Arguments"
        echo "    -e  Ephemeral, hidden HOST private key and hostname will be erased before start"
        echo
    } 1>&2
    exit 1
fi

ephemeral() {
    if [ "$1" = "-e" ]
    then
        rm -f "$self"/HOST/* || true
    fi
}

start() {
    ephemeral "$@"
}

finish() {
    ephemeral "$@"
}

start "$@"
trap "finish $@" EXIT

echo "Starting tor ..."
echo > "$self"/log
tor -f "$self"/torrc | tee "$self"/log &


while ! grep -w 'Bootstrapped 100% (done): Done' "$self"/log >> /dev/null
do
    sleep 1
    echo ""
    sleep 1
done
