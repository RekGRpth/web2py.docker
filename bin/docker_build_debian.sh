#!/bin/sh -eux

apt-get update
apt-get full-upgrade -y --no-install-recommends
apt-get install -y --no-install-recommends \
    apt-utils \
    file \
    gcc \
    git \
    gnutls-dev \
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
    python3-wcwidth \
    python3-willow \
    python3-xmltodict \
    swig \
    zlib1g-dev \
;
