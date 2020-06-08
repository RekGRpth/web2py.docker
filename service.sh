#!/bin/sh -ex

#docker build --tag rekgrpth/web2py .
#docker push rekgrpth/web2py
docker pull rekgrpth/web2py
docker network create --attachable --driver overlay docker || echo $?
docker volume create web2py
docker service rm web2py || echo $?
docker service create \
    --env GROUP_ID="$(id -g)" \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID="$(id -u)" \
    --hostname="{{.Service.Name}}-{{.Node.Hostname}}" \
    --mode global \
    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
    --mount type=bind,source=/run/postgresql,destination=/run/postgresql \
    --mount type=bind,source=/run/uwsgi,destination=/run/uwsgi \
    --mount type=bind,source=/var/log/uwsgi/web2py,destination=/var/log/uwsgi \
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
#    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
#    --mount type=bind,source=/run/postgresql,destination=/run/postgresql \
#    --mount type=bind,source=/run/uwsgi,destination=/run/uwsgi \
#    --mount type=bind,source=/var/log/uwsgi/web2py,destination=/var/log/uwsgi \
#    --mount type=volume,source=web2py,destination=/home \
#    --name scheduler \
#    --network name=docker \
#    rekgrpth/web2py su-exec web2py python -m supervisor.supervisord --configuration /home/supervisord.conf
