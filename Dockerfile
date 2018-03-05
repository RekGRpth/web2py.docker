FROM debian:jessie

MAINTAINER RekGRpth

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.10
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y --auto-remove ca-certificates wget

RUN apt-get update --yes --quiet && \
    apt-get upgrade --yes --quiet && \
    apt-get install --yes --quiet --no-install-recommends \
        ca-certificates \
        git \
        ipython \
        locales \
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
        && \
    mkdir --parents /home/user && \
    groupadd --system user && \
    useradd --system --gid user --home-dir /home/user --shell /sbin/nologin user && \
    usermod --append --groups video user && \
    ln --force --symbolic /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime && \
    echo "Asia/Yekaterinburg" > /etc/timezone && \
    apt-get remove --quiet --auto-remove --yes && \
    apt-get clean --quiet --yes && \
    rm --recursive --force /var/lib/apt/lists/* && \
    chown -R user:user /home/user && \
    localedef --inputfile=ru_RU --force --charmap=UTF-8 --alias-file=/usr/share/locale/locale.alias ru_RU.UTF-8

ENV LANG ru_RU.UTF-8
ENV HOME /home/user
ENV USER_ID 999
ENV GROUP_ID 999

RUN mkdir /docker-entrypoint.d
COPY docker-entrypoint.sh /usr/local/bin/
#COPY init.sh /docker-entrypoint.d/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]
