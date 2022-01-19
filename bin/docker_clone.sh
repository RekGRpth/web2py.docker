#!/bin/sh -eux

mkdir -p "$HOME/src"
cd "$HOME/src"
git clone -b master https://github.com/RekGRpth/pyhandlebars.git
git clone -b master https://github.com/RekGRpth/pyhtmldoc.git
git clone -b master https://github.com/RekGRpth/pymustach.git
