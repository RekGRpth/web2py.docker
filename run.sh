#!/bin/sh

#docker build --tag rekgrpth/web2py . || exit $?
#docker push rekgrpth/web2py || exit $?
docker stop web2py
docker stop scheduler
docker rm web2py
docker rm scheduler
docker pull rekgrpth/web2py || exit $?
docker volume create web2py || exit $?
docker network create my
docker run \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env USER_ID=$(id -u) \
    --hostname web2py \
    --link nginx:$(hostname -f) \
    --link nginx:cas-$(hostname -f) \
    --link nginx:web2py-$(hostname -f) \
    --name web2py \
    --network my \
    --restart always \
    --volume web2py:/home \
    rekgrpth/web2py uwsgi --ini web2py.ini
#docker run \
#    --detach \
#    --env GROUP_ID=$(id -g) \
#    --env USER_ID=$(id -u) \
#    --hostname scheduler \
#    --link nginx:web2py-$(hostname -f) \
#    --name scheduler \
#    --network my \
#    --restart always \
#    --volume web2py:/home \
#    rekgrpth/web2py su-exec web2py python -m supervisor.supervisord --configuration /home/supervisord.conf
