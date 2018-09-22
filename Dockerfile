FROM alpine

MAINTAINER RekGRpth

COPY ldap/ /usr/local/lib/python3.8/site-packages/ldap
ADD _ldap.cpython-38m-x86_64-linux-gnu.so /usr/local/lib/python3.8/site-packages/
ADD entrypoint.sh /
ADD font.sh /

ENV HOME=/data \
    LANG=ru_RU.UTF-8 \
    TZ=Asia/Yekaterinburg \
    USER=uwsgi \
    GROUP=uwsgi \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH=/data/app

RUN addgroup -S "${GROUP}" \
    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" ${USER} \
    && apk add --no-cache \
        libldap \
        shadow \
        sshpass \
        su-exec \
        ttf-dejavu \
        tzdata \
#        unixodbc-dev \
    && apk add --no-cache --virtual .build-deps \
        bzip2-dev \
        coreutils \
        curl \
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
    && mkdir -p /usr/src \
    && git clone --progress https://github.com/python/cpython.git /usr/src/python \
    && cd /usr/src/python \
    && ./configure \
        --enable-loadable-sqlite-extensions \
        --enable-shared \
        --with-ensurepip=upgrade \
        --with-system-expat \
        --with-system-ffi \
    && make -j "$(nproc)" \
    && make install \
    && cd /usr/local/bin \
    && ln -s idle3 idle \
    && ln -s pip3 pip \
    && ln -s pydoc3 pydoc \
    && ln -s python3 python \
    && ln -s python3-config python-config \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir \
        captcha \
        decorator \
        httplib2 \
        jwt \
#        ldap \
#        ldap3 \
        olefile \
        pexpect \
        pillow \
        pipdate \
        psycopg2 \
        ptyprocess \
        pygments \
#        pyldap \
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
    && pip3 install --no-cache-dir "git+https://github.com/Supervisor/supervisor" \
    && sed -i "s|from cgi import escape|try: from html import escape\nexcept ImportError: from cgi import escape|g" /usr/local/lib/python3.8/site-packages/supervisor/medusa/util.py \
    && (pipdate || true) \
    && pip install --no-cache-dir \
        ipython \
    && find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec scanelf --needed --nobanner --format '%n#p' '{}' ';' \
        | tr ',' '\n' \
        | sort -u \
        | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
        | xargs -rt apk add --no-cache --virtual .python-rundeps \
    && apk del .build-deps \
    && find /usr/local -depth \
        \( \
            \( -type d -a \( -name test -o -name tests \) \) \
#            -o \
#            \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
        \) -exec rm -rf '{}' + \
    && cd / \
    && rm -rf /usr/src /usr/local/include \
    && find -name "*.pyc" -delete \
    && find -name "*.pyo" -delete \
    && find -name "*.whl" -delete \
    && chmod +x /entrypoint.sh \
#    && usermod --home "${HOME}" "${USER}" \
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
