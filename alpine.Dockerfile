FROM alpine:latest
ADD bin /usr/local/bin
ENTRYPOINT [ "docker_entrypoint.sh" ]
ENV HOME=/home
MAINTAINER RekGRpth
WORKDIR "$HOME"
ADD fonts /usr/local/share/fonts
ADD service /etc/service
ARG DOCKER_PYTHON_VERSION=3.12
CMD [ "/etc/service/uwsgi/run" ]
ENV GROUP=web2py \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH="$HOME/app:$HOME/app/site-packages:$HOME/app/gluon/packages/dal:/usr/local/lib/python$DOCKER_PYTHON_VERSION:/usr/local/lib/python$DOCKER_PYTHON_VERSION/lib-dynload:/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages" \
    USER=web2py
RUN set -eux; \
    ln -fs su-exec /sbin/gosu; \
    chmod +x /usr/local/bin/*.sh; \
    apk update --no-cache; \
    apk upgrade --no-cache; \
    addgroup -S "$GROUP"; \
    adduser -S -D -G "$GROUP" -H -h "$HOME" -s /sbin/nologin "$USER"; \
    apk add --no-cache --virtual .build \
        autoconf \
        automake \
        bison \
        check-dev \
        cjson-dev \
        clang \
        cups-dev \
        file \
        flex \
        fltk-dev \
        g++ \
        gcc \
        git \
        grep \
        jansson-dev \
        jpeg-dev \
        json-c-dev \
        libffi-dev \
        libgcrypt-dev \
        libpng-dev \
        libtool \
        linux-headers \
        lmdb-dev \
        make \
        musl-dev \
        openldap-dev \
        pcre2-dev \
        pcre-dev \
        py3-cairo \
        py3-dateutil \
        py3-decorator \
        py3-defusedxml \
        py3-future \
        py3-html5lib \
        py3-httplib2 \
        py3-jwt \
        py3-lxml \
        py3-magic \
        py3-netaddr \
        py3-olefile \
        py3-openssl \
        py3-pexpect \
        py3-pillow \
        py3-pip \
        py3-psycopg2 \
        py3-ptyprocess \
        py3-pygments \
        py3-pyldap \
        py3-pypdf2 \
        py3-reportlab \
        py3-requests \
        py3-setuptools \
        py3-six \
        py3-suds-jurko \
        py3-tz \
        py3-wcwidth \
        py3-wheel \
        py3-xmltodict \
        python3-dev \
        subunit-dev \
        swig \
#        talloc-dev \
        yaml-dev \
        zlib-dev \
    ; \
    mkdir -p "$HOME/src"; \
    cd "$HOME/src"; \
    git clone -b master https://github.com/RekGRpth/htmldoc.git; \
    git clone -b master https://github.com/RekGRpth/mustach.git; \
#    git clone -b master https://github.com/RekGRpth/pyhandlebars.git; \
    git clone -b master https://github.com/RekGRpth/pyhtmldoc.git; \
    git clone -b master https://github.com/RekGRpth/pymustach.git; \
    ln -fs libldap.a /usr/lib/libldap_r.a; \
    ln -fs libldap.so /usr/lib/libldap_r.so; \
    cd "$HOME/src/htmldoc"; \
    ./configure --without-gui; \
    cd "$HOME/src/htmldoc/data"; \
    make -j"$(nproc)" install; \
    cd "$HOME/src/htmldoc/fonts"; \
    make -j"$(nproc)" install; \
    cd "$HOME/src/htmldoc/htmldoc"; \
    make -j"$(nproc)" install; \
    cd "$HOME/src/mustach"; \
    make -j"$(nproc)" libs=single install; \
#    cd "$HOME/src/pyhandlebars" && pip3 install --no-cache-dir --prefix /usr/local .; \
    cd "$HOME/src/pyhtmldoc"; \
    pip3 install --no-cache-dir --prefix /usr/local .; \
    cd "$HOME/src/pymustach"; \
    pip3 install --no-cache-dir --prefix /usr/local .; \
    cd "$HOME"; \
    pip install --no-cache-dir --prefix /usr/local \
        captcha \
        client_bank_exchange_1c \
        multiprocessing-utils \
        pg8000 \
        pyexcel-ods \
        python-ldap \
        python-pcre \
        requests-pkcs12 \
        sh \
#        suds2 \
        xhtml2pdf \
    ; \
    cd /; \
    apk add --no-cache --virtual .web2py \
        busybox-extras \
        busybox-suid \
        ca-certificates \
        ipython \
        libmagic \
        musl-locales \
        openssh-client \
        py3-dateutil \
        py3-decorator \
        py3-defusedxml \
        py3-future \
        py3-html5lib \
        py3-httplib2 \
        py3-jwt \
        py3-lxml \
        py3-magic \
        py3-netaddr \
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
        py3-tz \
        py3-wcwidth \
        py3-xmltodict \
        python3 \
        runit \
        sed \
        shadow \
        sshpass \
        su-exec \
        supervisor \
        tzdata \
        uwsgi-python3 \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | grep -v "^$" | grep -v -e libcrypto | sort -u | while read -r lib; do test -z "$(find /usr/local/lib -name "$lib")" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin -type f -exec strip '{}' \;; \
    find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;; \
    apk del --no-cache .build; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find /usr -type f -name "*.la" -delete; \
    find /usr -type f -name "*.pyc" -delete; \
    chmod -R 0755 /etc/service; \
#    grep -r "DEFAULT_CSS = \"\"\"" "/usr/lib/python$DOCKER_PYTHON_VERSION/site-packages/reportlab" "/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages/xhtml2pdf" | cut -d ':' -f 1 | sort -u | grep -E '.+\.py$' | while read -r FILE; do \
#        sed -i "/^DEFAULT_CSS/cfrom os import path, listdir\ndejavu = '/usr/local/share/fonts'\nfonts = {file.split('.')[0]: path.join(dejavu, file) for file in listdir(dejavu) if file.endswith('.ttf')}\nDEFAULT_CSS = '\\\n'.join(('@font-face { font-family: \"%s\"; src: \"%s\";%s%s }' % (name, file, ' font-weight: \"bold\";' if 'bold' in name.lower() else '', ' font-style: \"italic\";' if 'italic' in name.lower() or 'oblique' in name.lower() else '') for name, file in fonts.items())) + \"\"\"" "$FILE"; \
#    done; \
    mkdir -p "$HOME"; \
    chown -R "$USER":"$GROUP" "$HOME"; \
    echo done
