FROM debian:stretch-slim

MAINTAINER RekGRpth

RUN apt-get update --yes --quiet && \
    apt-get full-upgrade --yes --quiet && \
    apt-get install --yes --quiet --no-install-recommends \
        ca-certificates \
        ipython3 \
        locales \
        nginx-full \
        python3-dateutil \
        python3-git \
        python3-jwt \
        python3-ldap3 \
        python3-lxml \
        python3-netaddr \
        python3-openssl \
        python3-psutil \
        python3-psycopg2 \
        python3-pygraphviz \
        python3-pyldap \
        python3-sh \
        python3-suds \
        python3-xmltodict \
        supervisor \
        uwsgi \
        uwsgi-plugin-python3 \
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
    mkdir --parents /etc/nginx/conf.d/web2py && \
    rm --force /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default && \
    echo "daemon off;" >> /etc/nginx/nginx.conf && \
    echo "\"\\e[A\": history-search-backward" >> /etc/inputrc && \
    echo "\"\\e[B\": history-search-forward" >> /etc/inputrc

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
