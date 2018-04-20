#!/bin/sh

#docker build --tag rekgrpth/web2py . || exit $?
#docker push rekgrpth/web2py || exit $?
docker stop web2py
docker stop scheduler
docker rm web2py
docker rm scheduler
psql -h `hostname -f` -p 5555 -d scheduler -U scheduler -c "delete from scheduler_worker;"
docker pull rekgrpth/web2py || exit $?
docker volume create web2py || exit $?
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
docker run \
    --add-host `hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --add-host web2py-`hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --detach \
    --env USER_ID=$(id -u) \
    --env GROUP_ID=$(id -g) \
    --hostname scheduler \
    --name scheduler \
    --volume web2py:/data \
    rekgrpth/web2py su-exec uwsgi python web2py.py -K scheduler:main,scheduler:mailer/sender,scheduler:mailer/receiver,scheduler:smser/sender,scheduler:smser/stater
