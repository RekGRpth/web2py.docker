#!/bin/sh -eux

docker pull ghcr.io/rekgrpth/web2py.docker
docker volume create web2py
docker network create --attachable --opt com.docker.network.bridge.name=docker docker || echo $?
docker stop web2py || echo $?
docker rm web2py || echo $?
docker run \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID=$(id -u) \
    --hostname web2py \
    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
    --mount type=bind,source=/run/postgresql,destination=/run/postgresql \
    --mount type=bind,source=/run/uwsgi,destination=/run/uwsgi \
    --mount type=bind,source=/var/log/uwsgi/web2py,destination=/home/app/logs \
    --mount type=volume,source=web2py,destination=/home \
    --name web2py \
    --network name=docker \
    --restart always \
    ghcr.io/rekgrpth/web2py.docker runsvdir /etc/service
