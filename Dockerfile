FROM debian

MAINTAINER RekGRpth

RUN apt-get update --yes --quiet && \
    apt-get full-upgrade --yes --quiet && \
    apt-get install --yes --quiet --no-install-recommends \
        ca-certificates \
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
        supervisor \
        uwsgi \
        uwsgi-plugin-python \
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
    localedef --inputfile=ru_RU --force --charmap=UTF-8 --alias-file=/usr/share/locale/locale.alias ru_RU.UTF-8 && \
    mkdir --parents /etc/nginx/conf.d/web2py && \
    rm --force /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default && \
    echo "daemon off;" >> /etc/nginx/nginx.conf

ENV HOME /home/user
ENV LANG ru_RU.UTF-8
ENV USER_ID 999
ENV GROUP_ID 999
ENV PROCESSES auto

ADD gzip.conf /etc/nginx/conf.d/web2py/
ADD gzip_static.conf /etc/nginx/conf.d/web2py/
ADD nginx.conf /etc/nginx/sites-enabled/
ADD supervisord.conf /etc/supervisor/conf.d/
ADD uwsgi.ini /etc/uwsgi/apps-enabled/

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

WORKDIR $HOME/web2py

CMD ["/usr/bin/supervisord"]
