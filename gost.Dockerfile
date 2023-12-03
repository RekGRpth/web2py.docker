FROM ghcr.io/rekgrpth/web2py.docker:latest
RUN set -eux; \
    apk update --no-cache; \
    apk upgrade --no-cache; \
    apk add --no-cache --virtual .build \
        ca-certificates \
        cmake \
        findutils \
        gcc \
        gettext-dev \
        git \
        libintl \
        make \
        musl-dev \
        openssl \
        openssl-dev \
    ; \
    mkdir -p "$HOME/src"; \
    cd "$HOME/src"; \
    git clone --branch master --recurse-submodules https://github.com/RekGRpth/engine.git; \
    cd "$HOME/src/engine"; \
    cmake -DCMAKE_INSTALL_PREFIX=/usr .; \
    make -j"$(nproc)" install; \
    apk add --no-cache --virtual .gost \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | grep -v "^$" | grep -v -e libcrypto | sort -u | while read -r lib; do test -z "$(find /usr/local/lib -name "$lib")" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin -type f -exec strip '{}' \;; \
    find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;; \
    strip /usr/lib/engines*/gost.so*; \
    apk del --no-cache .build; \
    sed -i '/\[openssl_init\]/ a engines = engine_section' /etc/ssl/openssl.cnf; \
    sed -i '6i openssl_conf=openssl_def' /etc/ssl/openssl.cnf; \
    echo "# OpenSSL default section" >>/etc/ssl/openssl.cnf; \
    echo "[openssl_def]" >>/etc/ssl/openssl.cnf; \
    echo "engines = engine_section" >>/etc/ssl/openssl.cnf; \
    echo "# Engine scetion" >>/etc/ssl/openssl.cnf; \
    echo "[engine_section]" >>/etc/ssl/openssl.cnf; \
    echo "gost = gost_section" >>/etc/ssl/openssl.cnf; \
    echo "# Engine gost section" >>/etc/ssl/openssl.cnf; \
    echo "[gost_section]" >>/etc/ssl/openssl.cnf; \
    echo "engine_id = gost" >>/etc/ssl/openssl.cnf; \
    echo "default_algorithms = ALL" >>/etc/ssl/openssl.cnf; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find /usr -type f -name "*.la" -delete; \
    echo done
