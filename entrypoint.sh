#!/bin/sh

groupmod --gid "$GROUP_ID" user && \
usermod  --uid "$USER_ID" user && \
chown --recursive "$USER_ID":"$GROUP_ID" "$HOME" && \
sed -i "s|^user www-data;$|user user;|gi" "/etc/nginx/nginx.conf" && \
sed -i "s|^processes = 4$|processes = $(nproc --all)|gi" "/etc/uwsgi/apps-enabled/uwsgi.ini" && \
exec "$@"
