#!/bin/sh

groupmod --gid "$GROUP_ID" user
usermod  --uid "$USER_ID" user
chown --recursive "$USER_ID":"$GROUP_ID" "$HOME"

NGINX_CONF="/etc/nginx/nginx.conf"
UWSGI_CONF="/etc/uwsgi/apps-enabled/uwsgi.ini"

sed -i "/^user/cuser user;" "$NGINX_CONF"

if [ "$PROCESSES" != "auto" ]; then
    sed -i "/^worker_processes/cworker_processes $PROCESSES;" "$NGINX_CONF"
    sed -i "/^processes/cprocesses = $PROCESSES" "$UWSGI_CONF"
else
    sed -i "/^processes/cprocesses = $(nproc --all)" "$UWSGI_CONF"
fi

exec "$@"
