#!/bin/sh

docker pull rekgrpth/web2py && \
docker volume create web2py && \
docker run \
    --env USER_ID=$(id -u) \
    --env GROUP_ID=$(id -g) \
    --hostname web2py \
    --interactive \
    --name web2py \
    --tty \
    --volume web2py:/home/user \
    rekgrpth/web2py authbind --deep python /home/user/web2py/web2py.py
