FROM alpine

MAINTAINER RekGRpth

RUN apk add --no-cache \
#        alpine-sdk \
#        jpeg \
#        jpeg-dev \
        py3-dateutil \
        py3-decorator \
        py3-httplib2 \
        py3-olefile \
        py3-pexpect \
        py3-pillow \
        py3-psycopg2 \
        py3-ptyprocess \
        py3-pygments \
        py3-pyldap \
        py3-pypdf2 \
        py3-reportlab \
        py3-six \
        py3-wcwidth \
#        py-setuptools \
        python3 \
#        python3-dev \
        shadow \
        su-exec \
        tzdata \
        uwsgi-python3 \
#        zlib \
#        zlib-dev \
    && pip3 install --no-cache-dir \
        ipython \
        wkhtmltopdf \
        xhtml2pdf \
#    && apk del \
#        alpine-sdk \
#        jpeg-dev \
#        py-setuptools \
#        python3-dev \
#        zlib-dev \
    && find -name "*.pyc" -delete

ENV HOME=/data \
    LANG=ru_RU.UTF-8 \
    TZ=Asia/Yekaterinburg \
    USER=uwsgi \
    GROUP=uwsgi \
    PYTHONIOENCODING=UTF-8

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh && usermod --home "${HOME}" "${USER}"
ENTRYPOINT ["/entrypoint.sh"]

VOLUME  ${HOME}
WORKDIR ${HOME}/app

CMD [ "uwsgi", "--ini", "/data/uwsgi.ini" ]
