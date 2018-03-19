FROM alpine

RUN apk add --no-cache \
    shadow \
    python3 \
    uwsgi-python3 \
    py3-psycopg2 \
    py3-pyldap

RUN pip3 install --no-cache-dir \
    ipython

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

VOLUME /data
WORKDIR /data/web2py

CMD [ "uwsgi", "--ini", "/data/uwsgi.ini" ]
