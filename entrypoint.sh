#!/bin/sh

groupmod --gid "$GROUP_ID" user
usermod  --uid "$USER_ID" user
chown --recursive "$USER_ID":"$GROUP_ID" "$HOME"
sed -i "s|^user www-data;$|user user;|gi" "/etc/nginx/nginx.conf"
if [ "$PROCESSES" != "auto" ]; then
    sed -i "s|^worker_processes auto;$|worker_processes $PROCESSES;|gi" "/etc/nginx/nginx.conf"
    sed -i "s|^processes = 4$|processes = $PROCESSES|gi" "/etc/uwsgi/apps-enabled/uwsgi.ini"
else
    sed -i "s|^processes = 4$|processes = $(nproc --all)|gi" "/etc/uwsgi/apps-enabled/uwsgi.ini"
fi
exec "$@"
