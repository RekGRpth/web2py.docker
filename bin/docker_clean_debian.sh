#!/bin/sh -eux

cd /
apt-mark auto '.*' > /dev/null
apt-mark manual $savedAptMark
find /usr/local -type f -executable -exec ldd '{}' ';' | grep -v 'not found' | awk '/=>/ { print $(NF-1) }' | sort -u | xargs -r dpkg-query --search | cut -d: -f1 | sort -u | xargs -r apt-mark manual
find /usr/local -type f -executable -exec ldd '{}' ';' | grep -v 'not found' | awk '/=>/ { print $(NF-1) }' | sort -u | xargs -r -i echo "/usr{}" | xargs -r dpkg-query --search | cut -d: -f1 | sort -u  | xargs -r apt-mark manual
apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false
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
;
rm -rf /var/lib/apt/lists/* /var/cache/ldconfig/aux-cache /var/cache/ldconfig
