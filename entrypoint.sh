#!/bin/sh

if [ "$GROUP_ID" = "" ]; then GROUP_ID=$(id -g $GROUP); fi
if [ "$GROUP_ID" != "$(id -g $GROUP)" ]; then
    find / -group $GROUP -exec chgrp "$GROUP_ID" {} \;
    groupmod --gid "$GROUP_ID" $GROUP
fi

if [ "$USER_ID" = "" ]; then USER_ID=$(id -u $USER); fi
if [ "$USER_ID" != "$(id -u $USER)" ]; then
    find / -user $USER -exec chown "$USER_ID" {} \;
    usermod --uid "$USER_ID" $USER
fi

exec su-exec "$USER" "$@"
