FROM alpine

MAINTAINER RekGRpth

ADD entrypoint.sh /
ADD font.sh /

ENV GROUP=uwsgi \
    HOME=/data \
    LANG=ru_RU.UTF-8 \
    TZ=Asia/Yekaterinburg \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH=/data/app \
    USER=uwsgi

RUN addgroup -S "${GROUP}" \
    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}" \
    && echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories \
    && echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories \
    && echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
    && apk update --no-cache \
    && apk upgrade --no-cache \
    && apk add --no-cache --virtual .web2py-build-deps \
        gcc \
        git \
        jpeg-dev \
        libffi-dev \
        linux-headers \
        make \
        musl-dev \
        openldap-dev \
        pcre-dev \
        postgresql-dev \
        python3 \
        python3-dev \
        zlib-dev \
    && cd /usr/bin \
    && ln -s idle3 idle \
    && ln -s pip3 pip \
    && ln -s pydoc3 pydoc \
    && ln -s python3 python \
    && ln -s python3-config python-config \
    && cd / \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir \
        captcha \
        decorator \
        httplib2 \
        ipython \
        netaddr \
        olefile \
        pexpect \
        pillow \
        psycopg2 \
        ptyprocess \
        pygments \
        PyJWT \
        pyOpenSSL \
        pypdf2 \
        python-dateutil \
        python-ldap \
        reportlab \
        requests \
        sh \
        six \
        suds2 \
        tornado \
        uwsgi \
        wcwidth \
        xhtml2pdf \
    && pip install --no-cache-dir "git+https://github.com/RekGRpth/supervisor" \
    && apk add --no-cache --virtual .web2py-rundeps \
        $( scanelf --needed --nobanner --format '%n#p' --recursive /usr/lib \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/lib" $1 " ]") == 0 { next } { print "so:" $1 }' \
        ) \
        ca-certificates \
        openssh-client \
        shadow \
        sshpass \
        su-exec \
        ttf-dejavu \
        tzdata \
    && apk del --no-cache .web2py-build-deps \
    && find -name "*.pyc" -delete \
    && find -name "*.pyo" -delete \
    && find -name "*.whl" -delete \
    && chmod +x /entrypoint.sh \
    && sh /font.sh \
    && rm -rf /font.sh /root/.cache \
    && echo "[unix_http_server]" >> /etc/supervisord.conf \
    && echo "file=/tmp/supervisord.sock" >> /etc/supervisord.conf \
    && echo "[supervisord]" >> /etc/supervisord.conf \
    && echo "nodaemon=true" >> /etc/supervisord.conf \
    && echo "[rpcinterface:supervisor]" >> /etc/supervisord.conf \
    && echo "supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface" >> /etc/supervisord.conf \
    && echo "[supervisorctl]" >> /etc/supervisord.conf \
    && echo "serverurl=unix:///tmp/supervisord.sock" >> /etc/supervisord.conf \
    && echo "[include]" >> /etc/supervisord.conf \
    && echo "files = ${HOME}/app/applications/*/supervisor/*.conf" >> /etc/supervisord.conf

VOLUME "${HOME}"

WORKDIR "${HOME}/app"

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "uwsgi", "--ini", "/data/web2py.ini" ]
