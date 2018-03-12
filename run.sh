#!/bin/sh

docker pull rekgrpth/web2py && \
docker volume create web2py && \
docker run \
    --add-host `hostname -f`:`ip -4 addr show docker0 | grep -oP 'inet \K[\d.]+'` \
    --detach \
    --env USER_ID=$(id -u) \
    --env GROUP_ID=$(id -g) \
    --hostname web2py \
    --name web2py \
    --publish 443:4444 \
    --volume /etc/certs/t72.crt:/etc/nginx/ssl/web2py.crt:ro \
    --volume /etc/certs/t72.key:/etc/nginx/ssl/web2py.key:ro \
    --volume web2py:/home/user \
    rekgrpth/web2py
#    rekgrpth/web2py python /home/user/web2py/web2py.py --ip=0.0.0.0 --port=4444 --password="<recycle>" --ssl_certificate=/etc/certs/cert.crt --ssl_private_key=/etc/certs/cert.key --nogui --no-banner
