#!/bin/sh

for f in /docker-entrypoint.d/*; do
    case "$f" in
        *.sh) echo "$0: running $f"; . "$f" ;;
        *) echo "$0: ignoring $f" ;;
    esac
done && \
groupmod --gid $GROUP_ID user && \
usermod  --uid $USER_ID user && \
chown --recursive $USER_ID:$GROUP_ID /home/user && \
exec gosu user "$@"
