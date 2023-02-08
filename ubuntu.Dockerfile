FROM ghcr.io/rekgrpth/lib.docker:ubuntu
ADD fonts /usr/local/share/fonts
ADD service /etc/service
ARG DOCKER_PYTHON_VERSION=3.10
CMD [ "/etc/service/uwsgi/run" ]
ENV GROUP=web2py \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH="$HOME/app:$HOME/app/site-packages:$HOME/app/gluon/packages/dal:/usr/local/lib/python$DOCKER_PYTHON_VERSION:/usr/local/lib/python$DOCKER_PYTHON_VERSION/lib-dynload:/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages" \
    USER=web2py
RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get update; \
    apt-get full-upgrade -y --no-install-recommends; \
    export savedAptMark="$(apt-mark showmanual)"; \
    addgroup --system "$GROUP"; \
    adduser --system --disabled-password --home "$HOME" --shell /sbin/nologin --ingroup "$GROUP" "$USER"; \
    apt-get install -y --no-install-recommends \
        apt-utils \
        file \
        gcc \
        git \
#        gnutls-dev \
        libc-dev \
        libcjson-dev \
        libffi-dev \
        libfreetype6-dev \
        libjansson-dev \
        libjpeg-dev \
        libjson-c-dev \
        libldap2-dev \
        libopenjp2-7-dev \
        libpcre2-dev \
        libpcre3-dev \
        libsasl2-dev \
        libsubunit-dev \
        libtalloc-dev \
        libxml2-dev \
        libxslt-dev \
        make \
        python3-dateutil \
        python3-decorator \
        python3-dev \
        python3-html5lib \
        python3-httplib2 \
        python3-ipython \
        python3-jwt \
        python3-lxml \
        python3-magic \
        python3-netaddr \
        python3-olefile \
        python3-openssl \
        python3-pexpect \
        python3-pip \
        python3-psycopg2 \
        python3-ptyprocess \
        python3-pygments \
        python3-pyldap \
        python3-pypdf2 \
        python3-reportlab \
        python3-requests \
        python3-setuptools \
        python3-six \
        python3-suds \
        python3-wcwidth \
        python3-willow \
        python3-xmltodict \
        swig \
        zlib1g-dev \
    ; \
    mkdir -p "$HOME/src"; \
    cd "$HOME/src"; \
#    git clone -b master https://github.com/RekGRpth/pyhandlebars.git; \
    git clone -b master https://github.com/RekGRpth/pyhtmldoc.git; \
    git clone -b master https://github.com/RekGRpth/pymustach.git; \
#    cd "$HOME/src/pyhandlebars" && pip3 install --no-cache-dir --prefix /usr/local .; \
    cd "$HOME/src/pyhtmldoc" && pip3 install --no-cache-dir --prefix /usr/local .; \
    cd "$HOME/src/pymustach" && pip3 install --no-cache-dir --prefix /usr/local .; \
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
        xhtml2pdf \
    ; \
    cd /; \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    find /usr/local -type f -executable -exec ldd '{}' ';' | grep -v 'not found' | awk '/=>/ { print $(NF-1) }' | sort -u | xargs -r dpkg-query --search | cut -d: -f1 | sort -u | xargs -r apt-mark manual; \
    find /usr/local -type f -executable -exec ldd '{}' ';' | grep -v 'not found' | awk '/=>/ { print $(NF-1) }' | sort -u | xargs -r -i echo "/usr{}" | xargs -r dpkg-query --search | cut -d: -f1 | sort -u  | xargs -r apt-mark manual; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    apt-get install -y --no-install-recommends \
        libmagic1 \
        openssh-client \
        python3 \
        python3-dateutil \
        python3-decorator \
        python3-html5lib \
        python3-httplib2 \
        python3-ipython \
        python3-jwt \
        python3-lxml \
        python3-magic \
        python3-netaddr \
        python3-olefile \
        python3-openssl \
        python3-pexpect \
        python3-pip \
        python3-psycopg2 \
        python3-ptyprocess \
        python3-pygments \
        python3-pyldap \
        python3-pypdf2 \
        python3-reportlab \
        python3-requests \
        python3-setuptools \
        python3-six \
        python3-wcwidth \
        python3-willow \
        python3-xmltodict \
        runit \
        sed \
        sshpass \
        supervisor \
        uwsgi-plugin-python3 \
    ; \
    rm -rf /var/lib/apt/lists/* /var/cache/ldconfig/aux-cache /var/cache/ldconfig; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find /usr -type f -name "*.la" -delete; \
    find /usr -type f -name "*.pyc" -delete; \
    chmod -R 0755 /etc/service; \
    grep -r "DEFAULT_CSS = \"\"\"" "/usr/lib/python$DOCKER_PYTHON_VERSION/site-packages/reportlab" "/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages/xhtml2pdf" | cut -d ':' -f 1 | sort -u | grep -E '.+\.py$' | while read -r FILE; do \
        sed -i "/^DEFAULT_CSS/cfrom os import path, listdir\ndejavu = '/usr/local/share/fonts'\nfonts = {file.split('.')[0]: path.join(dejavu, file) for file in listdir(dejavu) if file.endswith('.ttf')}\nDEFAULT_CSS = '\\\n'.join(('@font-face { font-family: \"%s\"; src: \"%s\";%s%s }' % (name, file, ' font-weight: \"bold\";' if 'bold' in name.lower() else '', ' font-style: \"italic\";' if 'italic' in name.lower() or 'oblique' in name.lower() else '') for name, file in fonts.items())) + \"\"\"" "$FILE"; \
    done; \
    mkdir -p "$HOME"; \
    chown -R "$USER":"$GROUP" "$HOME"; \
    echo done
