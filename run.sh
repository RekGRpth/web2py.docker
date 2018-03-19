#!/bin/sh

docker build --tag rekgrpth/web2py . && \
docker push rekgrpth/web2py
docker stop web2py
docker rm web2py
docker pull rekgrpth/web2py && \
docker volume create web2py && \
docker run \
    --add-host `hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --add-host web2py-`hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --detach \
    --env USER_ID=$(id -u) \
    --env GROUP_ID=$(id -g) \
    --hostname web2py \
    --name web2py \
    --publish 4321:4321 \
    --volume web2py:/data \
    rekgrpth/web2py
