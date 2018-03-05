#!/bin/sh

test ! -d /home/user/web2py && cd /home/user && git clone --recursive https://github.com/web2py/web2py.git
