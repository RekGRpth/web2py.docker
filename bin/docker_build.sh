#!/bin/sh -eux

cd "$HOME/src/pyhandlebars"
python3 setup.py build
python3 setup.py install --prefix /usr/local
cd "$HOME/src/pyhtmldoc"
python3 setup.py build
python3 setup.py install --prefix /usr/local
cd "$HOME/src/pymustach"
python3 setup.py build
python3 setup.py install --prefix /usr/local
cd "$HOME"
pip install --no-cache-dir --prefix /usr/local \
    captcha \
    client_bank_exchange_1c \
    multiprocessing-utils \
    pg8000 \
    pyexcel-ods \
    python-ldap \
    python-pcre \
    sh \
    suds2 \
    xhtml2pdf \
;
