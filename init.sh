#!/bin/sh

sed -i "s|^user www-data;$|user user;|" "/etc/nginx/nginx.conf"
# && service uwsgi start && service nginx start
