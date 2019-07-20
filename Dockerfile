FROM rekgrpth/uwsgi
ENV PYTHONPATH=${HOME}/app:${HOME}/app/site-packages:${HOME}/app/gluon/packages/dal:/usr/local/lib/python3.7:/usr/local/lib/python3.7/lib-dynload:/usr/local/lib/python3.7/site-packages
VOLUME "${HOME}"
RUN apk update --no-cache \
    && apk upgrade --no-cache \
#    && addgroup -S "${GROUP}" \
#    && adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}" \
#    && apk add --no-cache --virtual .build-deps \
#        freeglut-dev \
#        freetype-dev \
#        gcc \
#        gettext-dev \
#        git \
#        harfbuzz-dev \
#        jbig2dec-dev \
#        jpeg-dev \
#        libffi-dev \
#        linux-headers \
#        make \
#        musl-dev \
#        openjpeg-dev \
#        openldap-dev \
#        pcre-dev \
#        postgresql-dev \
#        python3-dev \
#        swig \
#        zlib-dev \
    && ln -s pip3 /usr/bin/pip \
    && ln -s pydoc3 /usr/bin/pydoc \
    && ln -s python3 /usr/bin/python \
    && ln -s python3-config /usr/bin/python-config \
#    && pip install --no-cache-dir --upgrade pip \
 #   && mkdir -p /usr/src \
 #   && cd /usr/src \
 #   && git clone --recursive https://github.com/RekGRpth/pymupdf.git \
 #   && cd /usr/src/pymupdf \
 #   && python setup.py install --prefix /usr/local \
    && pip install --no-cache-dir --prefix /usr/local \
        captcha \
        client_bank_exchange_1c \
#        decorator \
#        httplib2 \
#        ipython \
        multiprocessing-utils \
#        netaddr \
#        olefile \
#        pexpect \
        pg8000 \
#        pillow \
#        psycopg2 \
#        ptyprocess \
#        pygments \
#        PyJWT \
#        pyOpenSSL \
#        pypdf2 \
#        python-dateutil \
#        python-ldap \
#        reportlab \
#        requests \
        sh \
#        six \
        suds2 \
        supervisor \
#        uwsgi \
#        wcwidth \
        xhtml2pdf \
    && apk add --no-cache --virtual .web2py-rundeps \
        openssh-client \
        sshpass \
        ttf-liberation \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }') \
#    && apk del --no-cache .build-deps \
    && rm -rf /usr/src /usr/local/share/doc /usr/local/share/man \
    && grep -r "Helvetica" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Helvetica|LiberationSans-Regular|g" "$FILE"; done \
    && grep -r "TimesNewRoman" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|TimesNewRoman|LiberationSerif-Regular|g" "$FILE"; done \
    && grep -r "Times New Roman" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Times New Roman|LiberationSerif-Regular|g" "$FILE"; done \
    && grep -r "Times-Roman" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Times-Roman|LiberationSerif-Regular|g" "$FILE"; done \
    && grep -r "Times-" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Times-|LiberationSerif-|g" "$FILE"; done \
    && grep -r "Arial" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Arial|LiberationSans-Regular|g" "$FILE"; done \
    && grep -r "Courier New" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Courier New|LiberationMono-Regular|g" "$FILE"; done \
    && grep -r "Courier" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|Courier|LiberationMono-Regular|g" "$FILE"; done \
    && grep -r "/usr/share/fonts/dejavu" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|/usr/share/fonts/dejavu|/usr/share/fonts/ttf-liberation|g" "$FILE"; done \
    && grep -r "DEFAULT_CSS = \"\"\"" /usr/lib/python3.7/site-packages/reportlab /usr/local/lib/python3.7/site-packages/xhtml2pdf | cut -d ':' -f 1 | sort -u | while read -r FILE; do sed -i "s|font-weight:bold;|font-weight:bold;font-family: LiberationSans-Bold;|g" "$FILE" \
    && sed -i "s|font-weight: bold;|font-weight:bold;font-family: LiberationSans-Bold;|g" "$FILE" \
    && sed -i "s|font-style: italic;|font-style: italic;font-family: LiberationSans-Italic;|g" "$FILE" \
    && sed -i "/^DEFAULT_CSS/cfrom os import path, listdir\ndejavu = '/usr/share/fonts/ttf-liberation'\nfonts = {file.split('.')[0]: path.join(dejavu, file) for file in listdir(dejavu) if file.endswith('.ttf')}\nDEFAULT_CSS = '\\\n'.join(('@font-face { font-family: \"%s\"; src: \"%s\";%s%s }' % (name, file, ' font-weight: \"bold\";' if 'bold' in name.lower() else '', ' font-style: \"italic\";' if 'italic' in name.lower() or 'oblique' in name.lower() else '') for name, file in fonts.items())) + \"\"\"" "$FILE"; done
