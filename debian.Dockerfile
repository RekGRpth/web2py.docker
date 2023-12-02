FROM debian:latest
ADD bin /usr/local/bin
ENTRYPOINT [ "docker_entrypoint.sh" ]
ENV HOME=/home
MAINTAINER RekGRpth
WORKDIR "$HOME"
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
    chmod +x /usr/local/bin/*.sh; \
    apt-get update; \
    apt-get full-upgrade -y --no-install-recommends; \
    export savedAptMark="$(apt-mark showmanual)"; \
    addgroup --system "$GROUP"; \
    adduser --system --disabled-password --home "$HOME" --shell /sbin/nologin --ingroup "$GROUP" "$USER"; \
    apt-get install -y --no-install-recommends \
        apt-utils \
        autoconf \
        automake \
        bison \
        ca-certificates \
        check \
        clang \
        file \
        flex \
        g++ \
        gcc \
        git \
#        gnutls-dev \
        libc-dev \
        libcjson-dev \
        libcups2-dev \
        libffi-dev \
        libfltk1.3-dev \
        libfreetype6-dev \
        libgcrypt20-dev \
        libjansson-dev \
        libjpeg-dev \
        libjson-c-dev \
        libldap2-dev \
        liblmdb-dev \
        libopenjp2-7-dev \
        libpcre2-dev \
        libpcre3-dev \
        libpng-dev \
        libsasl2-dev \
        libssl-dev \
        libsubunit-dev \
#        libtalloc-dev \
        libtool \
        libxml2-dev \
        libxslt-dev \
        libyaml-dev \
        make \
        pkg-config \
        python3-cairo \
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
    if [ -f /etc/dpkg/dpkg.cfg.d/docker ]; then \
        grep -q '/usr/share/locale' /etc/dpkg/dpkg.cfg.d/docker; \
        sed -ri '/\/usr\/share\/locale/d' /etc/dpkg/dpkg.cfg.d/docker; \
        ! grep -q '/usr/share/locale' /etc/dpkg/dpkg.cfg.d/docker; \
    fi; \
    apt-get install -y --no-install-recommends \
        adduser \
        ca-certificates \
        gosu \
        libmagic1 \
        locales \
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
        tzdata \
        uwsgi-plugin-python3 \
    ; \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8; \
    localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8; \
    locale-gen --lang ru_RU.UTF-8; \
    dpkg-reconfigure locales; \
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
