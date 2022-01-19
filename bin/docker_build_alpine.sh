#!/bin/sh -eux

apk update --no-cache
apk upgrade --no-cache
apk add --no-cache --virtual .build-deps \
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
    py3-tz \
    py3-wcwidth \
    py3-wheel \
    py3-xmltodict \
    python3-dev \
    swig \
    talloc-dev \
    zlib-dev \
;
