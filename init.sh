#!/bin/sh

touch /etc/authbind/byport/443
touch /etc/authbind/byport/80
chown $USER_ID:root /etc/authbind/byport/443
chown $USER_ID:root /etc/authbind/byport/80
chmod 500 /etc/authbind/byport/443
chmod 500 /etc/authbind/byport/80
if [ ! -d /home/user/web2py ]; then cd /home/user && git clone --recursive https://github.com/web2py/web2py.git; fi
