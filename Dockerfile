FROM debian

MAINTAINER RekGRpth

RUN apt-get update --yes --quiet && \
    apt-get full-upgrade --yes --quiet && \
    apt-get install --yes --quiet --no-install-recommends \
        ca-certificates \
        curl \
        git \
        gosu \
        ipython \
        locales \
        nginx-full \
        python-dateutil \
        python-git \
        python-jwt \
        python-ldap \
        python-lxml \
        python-netaddr \
        python-openssl \
        python-psutil \
        python-psycopg2 \
        python-pygraphviz \
        python-sh \
        python-suds \
        python-tk \
        python-xmltodict \
        sshpass \
        supervisor \
        uwsgi \
        uwsgi-core \
        uwsgi-emperor \
        uwsgi-plugin-python \
        wget \
        && \
    mkdir --parents /home/user && \
    groupadd --system user && \
    useradd --system --gid user --home-dir /home/user --shell /sbin/nologin user && \
    ln --force --symbolic /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime && \
    echo "Asia/Yekaterinburg" > /etc/timezone && \
    apt-get remove --quiet --auto-remove --yes && \
    apt-get clean --quiet --yes && \
    rm --recursive --force /var/lib/apt/lists/* && \
    chown -R user:user /home/user && \
    localedef --inputfile=ru_RU --force --charmap=UTF-8 --alias-file=/usr/share/locale/locale.alias ru_RU.UTF-8

ENV LANG ru_RU.UTF-8
#ENV HOME /home/user
#ENV USER_ID 999
#ENV GROUP_ID 999

RUN mkdir -p /docker-entrypoint.d && \
    mkdir -p /etc/nginx/conf.d/web2py && \
    mkdir -p /etc/nginx/ssl && \
    rm /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default && \
    sed -i "s|^user www-data;$|user user;|" "/etc/nginx/nginx.conf"
#COPY docker-entrypoint.sh /usr/local/bin/
ADD gzip_static.conf /etc/nginx/conf.d/web2py/gzip_static.conf
ADD gzip.conf /etc/nginx/conf.d/web2py/gzip.conf
ADD web2py /etc/nginx/sites-enabled/web2py
ADD web2py.ini /etc/uwsgi/apps-enabled/web2py.ini
ADD supervisor.conf /etc/supervisor/conf.d/

#COPY init.sh /docker-entrypoint.d/
#RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
#ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["supervisord", "-n"]

#WORKDIR $HOME/web2py

WORKDIR /home/user/web2py
