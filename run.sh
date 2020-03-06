#!/bin/sh

#docker build --tag rekgrpth/web2py . || exit $?
#docker push rekgrpth/web2py || exit $?
docker pull rekgrpth/web2py || exit $?
docker volume create web2py || exit $?
docker network create --attachable --opt com.docker.network.bridge.name=docker docker || echo $?
docker service create \
    --env GROUP_ID=$(id -g) \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID=$(id -u) \
    --hostname web2py \
    --mount type=bind,source=/etc/certs,destination=/etc/certs \
    --mount type=volume,source=web2py,destination=/home \
    --name web2py \
    --network name=docker \
    rekgrpth/web2py uwsgi --ini web2py.ini
#docker service create \
#    --env GROUP_ID=$(id -g) \
#    --env LANG=ru_RU.UTF-8 \
#    --env TZ=Asia/Yekaterinburg \
#    --env USER_ID=$(id -u) \
#    --hostname scheduler \
#    --mount type=bind,source=/etc/certs,destination=/etc/certs \
#    --mount type=volume,source=web2py,destination=/home \
#    --name scheduler \
#    --network name=docker \
#    rekgrpth/web2py su-exec web2py python -m supervisor.supervisord --configuration /home/supervisord.conf
