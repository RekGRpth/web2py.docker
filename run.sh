#!/bin/sh

#docker build --tag rekgrpth/web2py . || exit $?
#docker push rekgrpth/web2py || exit $?
docker stop web2py
docker stop scheduler
docker stop websocket
docker rm web2py
docker rm scheduler
docker rm websocket
docker pull rekgrpth/web2py || exit $?
docker volume create web2py || exit $?
docker network create my
docker run \
    --add-host `hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --add-host web2py-`hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --add-host websocket-`hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --detach \
    --env USER_ID=$(id -u) \
    --env GROUP_ID=$(id -g) \
    --hostname websocket \
    --name websocket \
    --network my \
    --restart always \
    --volume /etc/certs:/etc/certs \
    --volume web2py:/data \
    rekgrpth/web2py su-exec uwsgi python gluon/contrib/websocket_messaging.py -k web2py -p 8888
#    rekgrpth/web2py su-exec uwsgi python gluon/contrib/websocket_messaging.py -k web2py -p 8888 -s /etc/certs/`hostname -d`.key -c /etc/certs/`hostname -d`.crt
docker run \
    --add-host `hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --add-host web2py-`hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --add-host websocket-`hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --detach \
    --env USER_ID=$(id -u) \
    --env GROUP_ID=$(id -g) \
    --hostname web2py \
    --name web2py \
    --network my \
    --restart always \
    --volume web2py:/data \
    rekgrpth/web2py
docker run \
    --add-host `hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --add-host web2py-`hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --add-host websocket-`hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --detach \
    --env USER_ID=$(id -u) \
    --env GROUP_ID=$(id -g) \
    --hostname scheduler \
    --name scheduler \
    --network my \
    --restart always \
    --volume web2py:/data \
    rekgrpth/web2py su-exec uwsgi supervisord
