FROM rekgrpth/python

COPY ldap/ /usr/local/lib/python3.8/site-packages/ldap
ADD _ldap.cpython-38m-x86_64-linux-gnu.so /usr/local/lib/python3.8/site-packages/
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
    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" ${USER} \
    && apk add --no-cache \
        libldap \
        openssh-client \
        shadow \
        sshpass \
        su-exec \
        ttf-dejavu \
        tzdata \
    && apk add --no-cache --virtual .build-deps \
        bzip2-dev \
        coreutils \
        dpkg-dev dpkg \
        expat-dev \
        findutils \
        freetype-dev \
        gcc \
        gdbm-dev \
        git \
        jpeg-dev \
        libc-dev \
        libffi-dev \
        libnsl-dev \
        libressl-dev \
        libtirpc-dev \
        linux-headers \
        make \
        ncurses-dev \
        openldap-dev \
        pax-utils \
        postgresql-dev \
        readline-dev \
        sqlite-dev \
        tcl-dev \
        tk \
        tk-dev \
        util-linux-dev \
        xz-dev \
        zlib-dev \
    && pip install --no-cache-dir \
        captcha \
        decorator \
        httplib2 \
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
    && (pipdate || true) \
#    && pip install --no-cache-dir \
#        ipython \
    && find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' \
        | tr ',' '\n' \
        | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        | xargs -rt apk add --no-cache --virtual .python-rundeps \
    && apk del .build-deps \
    && find -name "*.pyc" -delete \
    && find -name "*.pyo" -delete \
    && find -name "*.whl" -delete \
    && chmod +x /entrypoint.sh \
    && sh /font.sh \
    && rm -f /font.sh \
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

VOLUME  "${HOME}"

WORKDIR "${HOME}/app"

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "uwsgi", "--ini", "/data/web2py.ini" ]
