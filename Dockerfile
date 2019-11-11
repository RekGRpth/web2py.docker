FROM rekgrpth/pdf
COPY fonts /usr/local/share/fonts
ENV GROUP=web2py \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH=${HOME}/app:${HOME}/app/site-packages:${HOME}/app/gluon/packages/dal:/usr/local/lib/python3.8:/usr/local/lib/python3.8/lib-dynload:/usr/local/lib/python3.8/site-packages \
    USER=web2py
VOLUME "${HOME}"
RUN set -ex \
    && addgroup -S "${GROUP}" \
    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}" \
    && ln -s pip3 /usr/bin/pip \
    && ln -s pydoc3 /usr/bin/pydoc \
    && ln -s python3 /usr/bin/python \
    && ln -s python3-config /usr/bin/python-config \
    && apk add --no-cache --virtual .build-deps \
        freetype-dev \
        gcc \
        gettext-dev \
        git \
        jpeg-dev \
        libffi-dev \
        libxml2-dev \
        libxslt-dev \
        linux-headers \
        make \
        musl-dev \
        openjpeg-dev \
        openldap-dev \
        pcre2-dev \
        pcre-dev \
        postgresql-dev \
        python3-dev \
        swig \
        zlib-dev \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone --recursive https://github.com/RekGRpth/pyhtmldoc.git \
    && cd /usr/src/pyhtmldoc \
    && python setup.py install --prefix /usr/local \
    && cd / \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --prefix /usr/local \
        captcha \
        client_bank_exchange_1c \
        decorator \
        html5lib \
        httplib2 \
        ipython \
        lxml \
        multiprocessing-utils \
        netaddr \
        olefile \
        pexpect \
        pg8000 \
        pillow \
        psycopg2 \
        ptyprocess \
        pygments \
        PyJWT \
        pyldap \
        pyOpenSSL \
        pypdf2 \
        python-dateutil \
        python-ldap \
        python-pcre \
        reportlab \
        requests \
        sh \
        six \
        suds2 \
        supervisor \
        uwsgi \
        wcwidth \
        xhtml2pdf \
    && apk add --no-cache --virtual .web2py-rundeps \
        openssh-client \
        python3 \
        sshpass \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }') \
    && (strip /usr/local/bin/* /usr/local/lib/*.so || true) \
    && apk del --no-cache .build-deps \
    && rm -rf /usr/src /usr/local/share/doc /usr/local/share/man \
    && grep -r "Helvetica" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Helvetica|NimbusSans-Regular|g" "$FILE"; done \
    && grep -r "TimesNewRoman" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|TimesNewRoman|NimbusRoman-Regular|g" "$FILE"; done \
    && grep -r "Times New Roman" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Times New Roman|NimbusRoman-Regular|g" "$FILE"; done \
    && grep -r "Times-Roman" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Times-Roman|NimbusRoman-Regular|g" "$FILE"; done \
    && grep -r "Times-" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Times-|NimbusRoman-|g" "$FILE"; done \
    && grep -r "Arial" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Arial|NimbusSans-Regular|g" "$FILE"; done \
    && grep -r "Courier New" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Courier New|NimbusMonoPS-Regular|g" "$FILE"; done \
    && grep -r "Courier" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Courier|NimbusMonoPS-Regular|g" "$FILE"; done \
    && grep -r "/usr/share/fonts/dejavu" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|/usr/share/fonts/dejavu|/usr/local/share/fonts|g" "$FILE"; done \
    && grep -r "DEFAULT_CSS = \"\"\"" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|font-weight:bold;|font-weight:bold;font-family: NimbusSans-Bold;|g" "$FILE" \
    && sed -i "s|font-weight: bold;|font-weight:bold;font-family: NimbusSans-Bold;|g" "$FILE" \
    && sed -i "s|font-style: italic;|font-style: italic;font-family: NimbusSans-Italic;|g" "$FILE" \
    && sed -i "/^DEFAULT_CSS/cfrom os import path, listdir\ndejavu = '/usr/local/share/fonts'\nfonts = {file.split('.')[0]: path.join(dejavu, file) for file in listdir(dejavu) if file.endswith('.ttf')}\nDEFAULT_CSS = '\\\n'.join(('@font-face { font-family: \"%s\"; src: \"%s\";%s%s }' % (name, file, ' font-weight: \"bold\";' if 'bold' in name.lower() else '', ' font-style: \"italic\";' if 'italic' in name.lower() or 'oblique' in name.lower() else '') for name, file in fonts.items())) + \"\"\"" "$FILE"; done
