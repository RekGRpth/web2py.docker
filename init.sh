#!/bin/sh

if [ ! -d /home/user/web2py ]; then
    cd /home/user && git clone --recursive https://github.com/web2py/web2py.git
else
    cd /home/user/web2py && git pull --recursive
fi
