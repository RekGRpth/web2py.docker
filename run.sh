#!/bin/sh -ex

#docker build --tag rekgrpth/web2py .
#docker push rekgrpth/web2py
docker pull rekgrpth/web2py
docker volume create web2py
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
    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
    --mount type=bind,source=/run/postgresql,destination=/run/postgresql \
    --mount type=bind,source=/run/uwsgi,destination=/run/uwsgi \
    --mount type=volume,source=web2py,destination=/home \
    --name web2py \
    --network name=docker \
    --restart always \
    rekgrpth/web2py uwsgi --ini web2py.ini
#docker run \
#    --detach \
#    --env GROUP_ID=$(id -g) \
#    --env LANG=ru_RU.UTF-8 \
#    --env TZ=Asia/Yekaterinburg \
#    --env USER_ID=$(id -u) \
#    --hostname scheduler \
#    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
#    --mount type=bind,source=/run/postgresql,destination=/run/postgresql \
#    --mount type=bind,source=/run/uwsgi,destination=/run/uwsgi \
#    --mount type=volume,source=web2py,destination=/home \
#    --name scheduler \
#    --network name=docker \
#    --restart always \
#    rekgrpth/web2py su-exec web2py python -m supervisor.supervisord --configuration /home/supervisord.conf
