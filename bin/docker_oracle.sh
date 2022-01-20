#!/bin/sh -eux

mkdir -p "$HOME/src"
cd "$HOME/src"
gcc -c fakeglibc.c -fPIC -o fakeglibc.o
gcc -shared -o /usr/local/lib/fakeglibc.so -fPIC fakeglibc.o
wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip
unzip instantclient-basiclite-linuxx64.zip
mkdir -p /usr/local/include /usr/local/bin /usr/local/lib
cp -r instantclient*/*.so* /usr/local/lib/
cd "$HOME"
ln -s /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1
ln -s /lib/libc.so.6 /usr/lib/libresolv.so.2
ln -s /lib64/ld-linux-x86-64.so.2 /usr/lib/ld-linux-x86-64.so.2
pip install --no-cache-dir --ignore-installed --prefix /usr/local \
    cx_Oracle \
;
