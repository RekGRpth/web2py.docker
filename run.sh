#!/bin/sh

#docker build --tag rekgrpth/web2py . || exit $?
#docker push rekgrpth/web2py || exit $?
docker pull rekgrpth/web2py || exit $?
docker volume create web2py || exit $?
docker network create --attachable --opt com.docker.network.bridge.name=docker docker || echo $?
docker stop web2py || echo $?
docker stop scheduler || echo $?
docker rm web2py || echo $?
docker rm scheduler || echo $?
docker run \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID=$(id -u) \
    --hostname web2py \
    --name web2py \
    --network name=docker \
    --restart always \
    --volume /etc/certs:/etc/certs \
    --volume /run/postgresql:/run/postgresql \
    --volume web2py:/home \
    rekgrpth/web2py uwsgi --ini web2py.ini
#docker run \
#    --detach \
#    --env GROUP_ID=$(id -g) \
#    --env LANG=ru_RU.UTF-8 \
#    --env TZ=Asia/Yekaterinburg \
#    --env USER_ID=$(id -u) \
#    --hostname scheduler \
#    --name scheduler \
#    --network name=docker \
#    --restart always \
#    --volume /etc/certs:/etc/certs \
#    --volume /run/postgresql:/run/postgresql \
#    --volume web2py:/home \
#    rekgrpth/web2py su-exec web2py python -m supervisor.supervisord --configuration /home/supervisord.conf
