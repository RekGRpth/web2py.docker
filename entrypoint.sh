#!/bin/sh

if [ "$GROUP_ID" = "" ]; then GROUP_ID=$(id -g "$GROUP"); fi
if [ "$GROUP_ID" != "$(id -g "$GROUP")" ]; then
    find / -group "$GROUP" -exec chgrp "$GROUP_ID" {} \;
    groupmod --gid "$GROUP_ID" "$GROUP"
fi

if [ "$USER_ID" = "" ]; then USER_ID=$(id -u "$USER"); fi
if [ "$USER_ID" != "$(id -u "$USER")" ]; then
    find / -user "$USER" -exec chown "$USER_ID" {} \;
    usermod --uid "$USER_ID" "$USER"
fi

find "$HOME" ! -group "$GROUP" -exec chgrp "$GROUP_ID" {} \;
find "$HOME" ! -user "$USER" -exec chown "$USER_ID" {} \;

find applications -type d -maxdepth 1 -mindepth 1 | grep -v "__pycache__" | while read APP; do
    APP="$(basename "$APP")"
    su-exec "$USER" "python3 web2py.py -Q -S $APP -M -R scripts/sessions2trash.py -A -o"
    su-exec "$USER" "python3 web2py.py -Q -S $APP -R scripts/zip_static_files.py"
done

exec "$@"
