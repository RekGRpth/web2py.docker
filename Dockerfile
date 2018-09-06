FROM alpine

MAINTAINER RekGRpth

ADD entrypoint.sh /
ADD font.sh /

ENV HOME=/data \
    LANG=ru_RU.UTF-8 \
    TZ=Asia/Yekaterinburg \
    USER=uwsgi \
    GROUP=uwsgi \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH=/data/app

RUN apk add --no-cache \
        alpine-sdk \
        git \
        libffi-dev \
        libldap \
        libpq \
        openldap-dev \
        openssh-client \
        postgresql-dev \
#        py3-dateutil \
#        py3-decorator \
#        py3-httplib2 \
#        py3-jwt \
#        py3-olefile \
#        py3-openssl \
#        py3-pexpect \
        py3-pillow \
        py3-psycopg2 \
#        py3-ptyprocess \
#        py3-pygments \
#        py3-pyldap \
#        py3-pypdf2 \
#        py3-reportlab \
#        py3-requests \
#        py3-six \
#        py3-tornado \
#        py3-wcwidth \
        python3 \
        python3-dev \
        shadow \
        sshpass \
        su-exec \
        ttf-dejavu \
        tzdata \
        unixodbc-dev \
        uwsgi-python3 \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir \
        decorator \
        httplib2 \
        ipython \
        jwt \
        olefile \
        pexpect \
#        pillow \
        psycopg2 \
        ptyprocess \
        pygments \
        pyldap \
        pyOpenSSL \
        pypdf2 \
        python-dateutil \
        reportlab \
        requests \
        sh \
        six \
        tornado \
#        uwsgi \
        wcwidth \
        xhtml2pdf \
    && pip3 install --no-cache-dir "git+https://github.com/Supervisor/supervisor" \
    && apk del \
        alpine-sdk \
        git \
        libffi-dev \
        openldap-dev \
        postgresql-dev \
        python3-dev \
    && find -name "*.pyc" -delete \
    && find -name "*.whl" -delete \
    && ln -fs python3 /usr/bin/python \
    && chmod +x /entrypoint.sh \
    && usermod --home "${HOME}" "${USER}" \
    && sh /font.sh \
    && rm -f /font.sh \
    && sed -i "/^                context=self._context, check_hostname=self._check_hostname)/c                context=self._context, check_hostname=self._check_hostname, port=443, key_file=None, cert_file=None)" /usr/lib/python3.6/urllib/request.py \
    && echo "[unix_http_server]" >> /etc/supervisord.conf \
    && echo "file=/tmp/supervisord.sock" >> /etc/supervisord.conf \
    && echo "[supervisord]" >> /etc/supervisord.conf \
    && echo "nodaemon=true" >> /etc/supervisord.conf \
    && echo "[rpcinterface:supervisor]" >> /etc/supervisord.conf \
    && echo "supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface" >> /etc/supervisord.conf \
    && echo "[supervisorctl]" >> /etc/supervisord.conf \
    && echo "serverurl=unix:///tmp/supervisord.sock" >> /etc/supervisord.conf \
    && echo "[include]" >> /etc/supervisord.conf \
    && echo "files = ${HOME}/app/applications/*/supervisor/*.conf" >> /etc/supervisord.conf

VOLUME  "${HOME}"

WORKDIR "${HOME}/app"

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "uwsgi", "--ini", "/data/web2py.ini" ]
