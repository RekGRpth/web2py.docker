#!/bin/sh

#docker build --tag rekgrpth/web2py . && \
#docker push rekgrpth/web2py
docker stop web2py
docker rm web2py
docker pull rekgrpth/web2py && \
docker volume create web2py && \
docker run \
    --add-host `hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --detach \
    --env USER_ID=$(id -u) \
    --env GROUP_ID=$(id -g) \
    --env PROCESSES=2 \
    --hostname web2py \
    --name web2py \
    --publish 4444:4444 \
    --volume /etc/certs/t72.crt:/etc/nginx/ssl/web2py.crt:ro \
    --volume /etc/certs/t72.key:/etc/nginx/ssl/web2py.key:ro \
    --volume web2py:/home/user \
    rekgrpth/web2py
