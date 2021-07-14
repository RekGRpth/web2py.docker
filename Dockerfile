FROM rekgrpth/pdf
CMD /etc/service/uwsgi/run
ENV GROUP=web2py \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH=${HOME}/app:${HOME}/app/site-packages:${HOME}/app/gluon/packages/dal:/usr/local/lib/python3.8:/usr/local/lib/python3.8/lib-dynload:/usr/local/lib/python3.8/site-packages \
    USER=web2py
VOLUME "${HOME}"
RUN set -eux; \
    addgroup -S "${GROUP}"; \
    adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}"; \
    ln -s pip3 /usr/bin/pip; \
    ln -s pydoc3 /usr/bin/pydoc; \
    ln -s python3 /usr/bin/python; \
    ln -s python3-config /usr/bin/python-config; \
    apk add --no-cache --virtual .build-deps \
        cargo \
        cjson-dev \
        clang \
        freetype-dev \
        gcc \
        gettext-dev \
        git \
        grep \
        jansson-dev \
        jpeg-dev \
        json-c-dev \
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
        py3-pip \
        python3-dev \
        rust \
        swig \
        talloc-dev \
        zlib-dev \
    ; \
    mkdir -p /usr/src; \
    cd /usr/src; \
    git clone https://bitbucket.org/RekGRpth/web2py.git; \
    git clone https://github.com/RekGRpth/pyhandlebars.git; \
    git clone https://github.com/RekGRpth/pyhtmldoc.git; \
    git clone https://github.com/RekGRpth/pymustach.git; \
    cd /usr/src/web2py; \
    mkdir -p /usr/local/share/fonts; \
    cp -rf fonts/* /usr/local/share/fonts; \
    mkdir -p /etc/service; \
    cp -rf service/* /etc/service; \
    cd /usr/src/pyhandlebars; \
    python setup.py install --prefix /usr/local; \
    cd /usr/src/pyhtmldoc; \
    python setup.py install --prefix /usr/local; \
    cd /usr/src/pymustach; \
    python setup.py install --prefix /usr/local; \
    cd /; \
    pip install --no-cache-dir --ignore-installed --prefix /usr/local \
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
        pyexcel-ods \
        pygments \
        PyJWT \
        pyldap \
        pyOpenSSL \
        pypdf2 \
        python-dateutil \
        python-ldap \
        python-magic \
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
    ; \
    apk add --no-cache --virtual .web2py-rundeps \
        libmagic \
        openssh-client \
        python3 \
        runit \
        sed \
        sshpass \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | while read -r lib; do test ! -e "/usr/local/lib/$lib" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin /usr/local/lib -type f -exec strip '{}' \;; \
    apk del --no-cache .build-deps; \
    rm -rf /usr/src /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find / -name "*.a" -delete; \
    find / -name "*.la" -delete; \
    chmod -R 0755 /etc/service; \
    find / -name "*.pyc" -delete; \
    grep -r "Helvetica" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | grep -E '.+\.py$' | while read -r FILE; do sed -i "s|Helvetica|NimbusSans-Regular|g" "$FILE"; done; \
    grep -r "TimesNewRoman" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | grep -E '.+\.py$' | while read -r FILE; do sed -i "s|TimesNewRoman|NimbusRoman-Regular|g" "$FILE"; done; \
    grep -r "Times New Roman" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | grep -E '.+\.py$' | while read -r FILE; do sed -i "s|Times New Roman|NimbusRoman-Regular|g" "$FILE"; done; \
    grep -r "Times-Roman" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | grep -E '.+\.py$' | while read -r FILE; do sed -i "s|Times-Roman|NimbusRoman-Regular|g" "$FILE"; done; \
    grep -r "Times-" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | grep -E '.+\.py$' | while read -r FILE; do sed -i "s|Times-|NimbusRoman-|g" "$FILE"; done; \
    grep -r "Arial" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | grep -E '.+\.py$' | while read -r FILE; do sed -i "s|Arial|NimbusSans-Regular|g" "$FILE"; done; \
    grep -r "Courier New" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | grep -E '.+\.py$' | while read -r FILE; do sed -i "s|Courier New|NimbusMonoPS-Regular|g" "$FILE"; done; \
    grep -r "Courier" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | grep -E '.+\.py$' | while read -r FILE; do sed -i "s|Courier|NimbusMonoPS-Regular|g" "$FILE"; done; \
    grep -r "/usr/share/fonts/dejavu" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | grep -E '.+\.py$' | while read -r FILE; do sed -i "s|/usr/share/fonts/dejavu|/usr/local/share/fonts|g" "$FILE"; done; \
    grep -r "DEFAULT_CSS = \"\"\"" /usr/local/lib/python3.8/site-packages/reportlab /usr/local/lib/python3.8/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | grep -E '.+\.py$' | while read -r FILE; do sed -i "s|font-weight:bold;|font-weight:bold;font-family: NimbusSans-Bold;|g" "$FILE"; \
    sed -i "s|font-weight: bold;|font-weight:bold;font-family: NimbusSans-Bold;|g" "$FILE"; \
    sed -i "s|font-style: italic;|font-style: italic;font-family: NimbusSans-Italic;|g" "$FILE"; \
    sed -i "/^DEFAULT_CSS/cfrom os import path, listdir\ndejavu = '/usr/local/share/fonts'\nfonts = {file.split('.')[0]: path.join(dejavu, file) for file in listdir(dejavu) if file.endswith('.ttf')}\nDEFAULT_CSS = '\\\n'.join(('@font-face { font-family: \"%s\"; src: \"%s\";%s%s }' % (name, file, ' font-weight: \"bold\";' if 'bold' in name.lower() else '', ' font-style: \"italic\";' if 'italic' in name.lower() or 'oblique' in name.lower() else '') for name, file in fonts.items())) + \"\"\"" "$FILE"; done; \
    echo done
