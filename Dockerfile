FROM rekgrpth/pdf
ENV GROUP=uwsgi \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH=${HOME}/app:${HOME}/app/site-packages:${HOME}/app/gluon/packages/dal:/usr/local/lib/python3.7:/usr/local/lib/python3.7/lib-dynload:/usr/local/lib/python3.7/site-packages \
    USER=uwsgi
VOLUME "${HOME}"
RUN set -ex \
    && apk update --no-cache \
    && apk upgrade --no-cache \
    && addgroup -S "${GROUP}" \
    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}" \
    && apk add --no-cache --virtual .uwsgi-rundeps \
        ipython \
        uwsgi \
        uwsgi-python3 \
    && ln -s pip3 /usr/bin/pip \
    && ln -s pydoc3 /usr/bin/pydoc \
    && ln -s python3 /usr/bin/python \
    && ln -s python3-config /usr/bin/python-config \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        git \
        make \
        musl-dev \
        python3-dev \
        swig \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone --recursive https://github.com/RekGRpth/pyhtmldoc.git \
    && cd /usr/src/pyhtmldoc \
    && python setup.py install --prefix /usr/local \
    && apk add --no-cache --virtual .web2py-rundeps \
        openssh-client \
        py3-dateutil \
        py3-decorator \
        py3-html5lib \
        py3-httplib2 \
        py3-jwt \
        py3-ldap3 \
        py3-lxml \
        py3-netaddr \
        py3-olefile \
        py3-openssl \
        py3-pexpect \
        py3-pillow \
        py3-psycopg2 \
        py3-ptyprocess \
        py3-pygments \
        py3-pyldap \
        py3-pypdf2 \
        py3-reportlab \
        py3-requests \
        py3-six \
        py3-wcwidth \
        sshpass \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }') \
    && (strip /usr/local/bin/* /usr/local/lib/*.so || true) \
    && apk del --no-cache .build-deps \
    && rm -rf /usr/src /usr/local/share/doc /usr/local/share/man \
    && cd / \
    && pip install --no-cache-dir --prefix /usr/local \
        captcha \
        client_bank_exchange_1c \
        multiprocessing-utils \
        pg8000 \
        sh \
        suds2 \
        supervisor \
        xhtml2pdf \
    && grep -r "Helvetica" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Helvetica|DejaVuSans|g" "$FILE"; done \
    && grep -r "TimesNewRoman" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|TimesNewRoman|DejaVuSerif|g" "$FILE"; done \
    && grep -r "Times New Roman" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Times New Roman|DejaVuSerif|g" "$FILE"; done \
    && grep -r "Times-Roman" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Times-Roman|DejaVuSerif|g" "$FILE"; done \
    && grep -r "Times-" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Times-|DejaVuSerif-|g" "$FILE"; done \
    && grep -r "Arial" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Arial|DejaVuSans|g" "$FILE"; done \
    && grep -r "Courier New" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Courier New|DejaVuSansMono|g" "$FILE"; done \
    && grep -r "Courier" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Courier|DejaVuSansMono|g" "$FILE"; done \
    && grep -r "/usr/share/fonts/dejavu" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|/usr/share/fonts/dejavu|/usr/share/fonts/ttf-dejavu|g" "$FILE"; done \
    && grep -r "DEFAULT_CSS = \"\"\"" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|font-weight:bold;|font-weight:bold;font-family: DejaVuSans-Bold;|g" "$FILE" \
    && sed -i "s|font-weight: bold;|font-weight:bold;font-family: DejaVuSans-Bold;|g" "$FILE" \
    && sed -i "s|font-style: italic;|font-style: italic;font-family: DejaVuSans-Oblique;|g" "$FILE" \
    && sed -i "/^DEFAULT_CSS/cfrom os import path, listdir\ndejavu = '/usr/share/fonts/ttf-dejavu'\nfonts = {file.split('.')[0]: path.join(dejavu, file) for file in listdir(dejavu) if file.endswith('.ttf')}\nDEFAULT_CSS = '\\\n'.join(('@font-face { font-family: \"%s\"; src: \"%s\";%s%s }' % (name, file, ' font-weight: \"bold\";' if 'bold' in name.lower() else '', ' font-style: \"italic\";' if 'italic' in name.lower() or 'oblique' in name.lower() else '') for name, file in fonts.items())) + \"\"\"" "$FILE"; done
