FROM alpine

MAINTAINER RekGRpth

RUN apk add --no-cache \
        py3-dateutil \
        py3-psycopg2 \
        py3-pyldap \
        python3 \
        shadow \
        su-exec \
        tzdata \
        uwsgi-python3 \
    && pip3 install --no-cache-dir \
        ipython \
    && find -name "*.pyc" -delete

ENV HOME=/data \
    LANG=ru_RU.UTF-8 \
    TZ=Asia/Yekaterinburg \
    USER=uwsgi \
    GROUP=uwsgi \
    PYTHONIOENCODING=UTF-8

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh && usermod --home "${HOME}" "${USER}"

VOLUME  ${HOME}
WORKDIR ${HOME}/app

ENTRYPOINT ["/entrypoint.sh"]
CMD [ "uwsgi", "--ini", "/data/uwsgi.ini" ]
