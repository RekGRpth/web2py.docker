FROM ghcr.io/rekgrpth/lib.docker:latest
ADD fonts /usr/local/share/fonts
ADD service /etc/service
ARG DOCKER_PYTHON_VERSION=3.10
CMD [ "/etc/service/uwsgi/run" ]
ENV GROUP=web2py \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH="$HOME/app:$HOME/app/site-packages:$HOME/app/gluon/packages/dal:/usr/local/lib/python$DOCKER_PYTHON_VERSION:/usr/local/lib/python$DOCKER_PYTHON_VERSION/lib-dynload:/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages" \
    USER=web2py
RUN set -eux; \
    apk update --no-cache; \
    apk upgrade --no-cache; \
    addgroup -S "$GROUP"; \
    adduser -S -D -G "$GROUP" -H -h "$HOME" -s /sbin/nologin "$USER"; \
    apk add --no-cache --virtual .build \
        cjson-dev \
        gcc \
        git \
        grep \
        jansson-dev \
        json-c-dev \
        libffi-dev \
        linux-headers \
        make \
        musl-dev \
        openldap-dev \
        pcre2-dev \
        pcre-dev \
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
        swig \
        talloc-dev \
        zlib-dev \
    ; \
    mkdir -p "$HOME/src"; \
    cd "$HOME/src"; \
#    git clone -b master https://github.com/RekGRpth/pyhandlebars.git; \
    git clone -b master https://github.com/RekGRpth/pyhtmldoc.git; \
    git clone -b master https://github.com/RekGRpth/pymustach.git; \
#    cd "$HOME/src/pyhandlebars" && python3 setup.py build && python3 setup.py install --prefix /usr/local; \
    cd "$HOME/src/pyhtmldoc" && python3 setup.py build && python3 setup.py install --prefix /usr/local; \
    cd "$HOME/src/pymustach" && python3 setup.py build && python3 setup.py install --prefix /usr/local; \
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
        ipython \
        libmagic \
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
        sshpass \
        supervisor \
        uwsgi-python3 \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | grep -v "^$" | grep -v -e libcrypto | sort -u | while read -r lib; do test -z "$(find /usr/local/lib -name "$lib")" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin -type f -exec strip '{}' \;; \
    find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;; \
    apk del --no-cache .build; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    rm -rf "/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages/pgadmin4/docs"; \
    find /usr -type f -name "*.la" -delete; \
    find /usr -type f -name "*.pyc" -delete; \
    chmod -R 0755 /etc/service; \
    grep -r "DEFAULT_CSS = \"\"\"" "/usr/lib/python$DOCKER_PYTHON_VERSION/site-packages/reportlab" "/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages/xhtml2pdf" | cut -d ':' -f 1 | sort -u | grep -E '.+\.py$' | while read -r FILE; do \
        sed -i "/^DEFAULT_CSS/cfrom os import path, listdir\ndejavu = '/usr/local/share/fonts'\nfonts = {file.split('.')[0]: path.join(dejavu, file) for file in listdir(dejavu) if file.endswith('.ttf')}\nDEFAULT_CSS = '\\\n'.join(('@font-face { font-family: \"%s\"; src: \"%s\";%s%s }' % (name, file, ' font-weight: \"bold\";' if 'bold' in name.lower() else '', ' font-style: \"italic\";' if 'italic' in name.lower() or 'oblique' in name.lower() else '') for name, file in fonts.items())) + \"\"\"" "$FILE"; \
    done; \
    mkdir -p "$HOME"; \
    chown -R "$USER":"$GROUP" "$HOME"; \
    echo done
