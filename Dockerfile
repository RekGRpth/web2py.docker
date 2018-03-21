FROM alpine

MAINTAINER RekGRpth

RUN apk add --no-cache \
        py3-psycopg2 \
        py3-pyldap \
        python3 \
        shadow \
        su-exec \
        tzdata \
        uwsgi-python3
    && find -name "*.pyc" -delete

RUN pip3 install --no-cache-dir \
        ipython
    && find -name "*.pyc" -delete

ENV HOME=/data \
    LANG=ru_RU.UTF-8 \
    TZ=Asia/Yekaterinburg

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

VOLUME  /data
WORKDIR /data/web2py

CMD [ "uwsgi", "--ini", "/data/uwsgi.ini" ]
