#!/bin/sh

cd /home/user && git clone --recursive https://github.com/web2py/web2py.git
rm -f /docker-entrypoint.d/init.sh
