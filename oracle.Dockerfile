FROM ghcr.io/rekgrpth/web2py.docker:latest
ADD fakeglibc.c "$HOME/src/"
ENV LD_PRELOAD=/usr/local/lib/fakeglibc.so
RUN set -eux; \
    apk update --no-cache; \
    apk upgrade --no-cache; \
    apk add --no-cache --virtual .build \
        gcc \
        musl-dev \
        py3-pip \
        python3-dev \
    ; \
    mkdir -p "$HOME/src"; \
    cd "$HOME/src"; \
    gcc -c fakeglibc.c -fPIC -o fakeglibc.o; \
    gcc -shared -o /usr/local/lib/fakeglibc.so -fPIC fakeglibc.o; \
    wget https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip; \
    unzip instantclient-basiclite-linuxx64.zip; \
    mkdir -p /usr/local/include /usr/local/bin /usr/local/lib; \
    cp -r instantclient*/*.so* /usr/local/lib/; \
    cd "$HOME"; \
    ln -s /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1; \
    ln -s /lib/libc.so.6 /usr/lib/libresolv.so.2; \
    ln -s /lib64/ld-linux-x86-64.so.2 /usr/lib/ld-linux-x86-64.so.2; \
    pip install --no-cache-dir --ignore-installed --prefix /usr/local \
        cx_Oracle \
    ; \
    cd /; \
    apk add --no-cache --virtual .oracle \
        libaio \
        libc6-compat \
        libnsl \
    ; \
    apk del --no-cache .build; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find /usr -type f -name "*.la" -delete; \
    find /usr -type f -name "*.pyc" -delete; \
    mkdir -p "$HOME"; \
    chown -R "$USER":"$GROUP" "$HOME"; \
    echo done
