FROM rekgrpth/gost

MAINTAINER RekGRpth

ADD entrypoint.sh /
ADD font.sh /

ENV GROUP=uwsgi \
    HOME=/data \
    LANG=ru_RU.UTF-8 \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH=/data/app:/data/app/site-packages:/data/app/gluon/packages/dal:/usr/local/lib/python3.7:/usr/local/lib/python3.7/lib-dynload:/usr/local/lib/python3.7/site-packages \
    TZ=Asia/Yekaterinburg \
    USER=uwsgi

RUN apk update --no-cache \
    && apk upgrade --no-cache \
    && addgroup -S "${GROUP}" \
    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}" \
    && apk add --no-cache --virtual .build-deps \
        freetype-dev \
        gcc \
        gettext-dev \
        git \
        jpeg-dev \
        libffi-dev \
        linux-headers \
        make \
        musl-dev \
        openldap-dev \
        postgresql-dev \
        pcre-dev \
        python3-dev \
        zlib-dev \
    && ln -s pip3 /usr/bin/pip \
    && ln -s pydoc3 /usr/bin/pydoc \
    && ln -s python3 /usr/bin/python \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --prefix /usr/local \
        captcha \
        client_bank_exchange_1c \
        decorator \
        httplib2 \
        ipython \
        multiprocessing-utils \
        netaddr \
        olefile \
        pexpect \
        pg8000 \
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
        supervisor \
        uwsgi \
        wcwidth \
        xhtml2pdf \
    && apk add --no-cache --virtual .web2py-rundeps \
        $( scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        ) \
        openssh-client \
        sshpass \
        ttf-liberation \
        uwsgi-python3 \
    && apk del --no-cache .build-deps \
    && chmod +x /entrypoint.sh \
    && sh /font.sh \
    && rm -rf /font.sh

VOLUME "${HOME}"

WORKDIR "${HOME}/app"

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "uwsgi", "--ini", "/data/web2py.ini" ]
