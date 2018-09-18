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
docker run \
    --add-host `hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --add-host web2py-`hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --add-host websocket-`hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --detach \
    --env USER_ID=$(id -u) \
    --env GROUP_ID=$(id -g) \
    --hostname websocket \
    --link postgres \
    --name websocket \
    --restart always \
    --volume /etc/certs:/etc/certs:ro \
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
    --link postgres \
    --link websocket \
    --name web2py \
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
    --link postgres \
    --link websocket \
    --name scheduler \
    --restart always \
    --volume web2py:/data \
    rekgrpth/web2py su-exec uwsgi supervisord
