#!/bin/sh

test ! -d /home/user/web2py && cd /home/user && git clone --recursive https://github.com/web2py/web2py.git && cd /home/user/web2py && python -c "from gluon.main import save_password; save_password('$PASSWORD', 4444)"
