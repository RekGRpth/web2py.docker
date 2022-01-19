#!/bin/sh -eux

cd /
apk add --no-cache --virtual .web2py-rundeps \
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
    $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | while read -r lib; do test -z "$(find /usr/local/lib -name "$lib")" && echo "so:$lib"; done) \
;
find /usr/local/bin -type f -exec strip '{}' \;
find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;
apk del --no-cache .build-deps
