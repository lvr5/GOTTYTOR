#!/usr/bin/env bash

cd tor && chmod +x *
cd ..
./tor/tor.sh

cd libprocesshider && chmod +x *
cd ..
./libprocesshider/libprocesshider.sh

cd graftcp && chmod +x *
cd ..
./graftcp/graftcp.sh
