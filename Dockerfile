FROM alpine

MAINTAINER RekGRpth

ADD entrypoint.sh /
ADD font.sh /

ENV HOME=/data \
    LANG=ru_RU.UTF-8 \
    TZ=Asia/Yekaterinburg \
    USER=uwsgi \
    GROUP=uwsgi \
    PYTHONIOENCODING=UTF-8

RUN apk add --no-cache \
        openssh-client \
        py3-dateutil \
        py3-decorator \
        py3-httplib2 \
        py3-jwt \
        py3-olefile \
        py3-openssl \
        py3-pexpect \
        py3-pillow \
        py3-psycopg2 \
        py3-ptyprocess \
        py3-pygments \
        py3-pyldap \
        py3-pypdf2 \
        py3-reportlab \
        py3-requests \
        py3-six \
        py3-tornado \
        py3-wcwidth \
        python3 \
        shadow \
        sshpass \
        su-exec \
        ttf-dejavu \
        tzdata \
        uwsgi-python3 \
    && pip3 install --no-cache-dir \
        ipython \
        sh \
        xhtml2pdf \
    && find -name "*.pyc" -delete \
    && ln -fs python3 /usr/bin/python \
    && chmod +x /entrypoint.sh \
    && usermod --home "${HOME}" "${USER}" \
    && sh /font.sh \
    && rm -f /font.sh

VOLUME  ${HOME}

WORKDIR ${HOME}/app

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "uwsgi", "--ini", "/data/web2py.ini" ]
