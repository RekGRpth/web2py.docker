FROM debian:buster-slim

MAINTAINER RekGRpth

RUN apt-get update --yes --quiet && \
    apt-get full-upgrade --yes --quiet && \
    apt-get install --yes --quiet --no-install-recommends \
        ca-certificates \
        ipython3 \
        locales \
        nginx-full \
        python3-psycopg2 \
        python3-pyldap \
        supervisor \
        uwsgi \
        uwsgi-plugin-python3 \
        && \
    apt-get remove --quiet --auto-remove --yes && \
    apt-get clean --quiet --yes && \
    rm --recursive --force /var/lib/apt/lists/*

RUN mkdir --parents /home/user && \
    groupadd --system user && \
    useradd --system --gid user --home-dir /home/user --shell /sbin/nologin user && \
    chown -R user:user /home/user && \
    ln --force --symbolic /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime && \
    echo "Asia/Yekaterinburg" > /etc/timezone && \
    echo "\"\\e[A\": history-search-backward" >> /etc/inputrc && \
    echo "\"\\e[B\": history-search-forward" >> /etc/inputrc

RUN mkdir --parents /etc/nginx/conf.d/web2py && \
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
