#!/usr/bin/env bash

cat >> graftcp-local.conf <<END
listen = :2233
loglevel = 1
socks5 = 127.0.0.1:9050
select_proxy_mode = auto
END

./graftcp-local -config graftcp-local.conf & sleep 2
