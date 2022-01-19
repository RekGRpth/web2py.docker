ARG DOCKER_FROM=lib.docker:latest
FROM "ghcr.io/rekgrpth/$DOCKER_FROM"
ADD bin /usr/local/bin
ADD fonts /usr/local/share/fonts
ADD service /etc/service
ARG DOCKER_BUILD=build
ARG DOCKER_PYTHON_VERSION=3.9
CMD [ "/etc/service/uwsgi/run" ]
ENV GROUP=web2py \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH="$HOME/app:$HOME/app/site-packages:$HOME/app/gluon/packages/dal:/usr/local/lib/python$DOCKER_PYTHON_VERSION:/usr/local/lib/python$DOCKER_PYTHON_VERSION/lib-dynload:/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages" \
    USER=web2py
RUN set -eux; \
    export DOCKER_BUILD="$DOCKER_BUILD"; \
    export DOCKER_TYPE="$(cat /etc/os-release | grep -E '^ID=' | cut -f2 -d '=')"; \
    if [ $DOCKER_TYPE != "alpine" ]; then \
        export DEBIAN_FRONTEND=noninteractive; \
        export savedAptMark="$(apt-mark showmanual)"; \
    fi; \
    chmod +x /usr/local/bin/*.sh; \
    test "$DOCKER_BUILD" = "build" && "docker_add_group_and_user_$DOCKER_TYPE.sh"; \
    "docker_${DOCKER_BUILD}_$DOCKER_TYPE.sh"; \
    docker_clone.sh; \
    "docker_$DOCKER_BUILD.sh"; \
    "docker_clean_$DOCKER_TYPE.sh"; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find /usr -type f -name "*.la" -delete; \
    find /usr -type f -name "*.pyc" -delete; \
    chmod -R 0755 /etc/service; \
    grep -r "DEFAULT_CSS = \"\"\"" "/usr/lib/python$DOCKER_PYTHON_VERSION/site-packages/reportlab" "/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages/xhtml2pdf" | cut -d ':' -f 1 | sort -u | grep -E '.+\.py$' | while read -r FILE; do \
        sed -i "/^DEFAULT_CSS/cfrom os import path, listdir\ndejavu = '/usr/local/share/fonts'\nfonts = {file.split('.')[0]: path.join(dejavu, file) for file in listdir(dejavu) if file.endswith('.ttf')}\nDEFAULT_CSS = '\\\n'.join(('@font-face { font-family: \"%s\"; src: \"%s\";%s%s }' % (name, file, ' font-weight: \"bold\";' if 'bold' in name.lower() else '', ' font-style: \"italic\";' if 'italic' in name.lower() or 'oblique' in name.lower() else '') for name, file in fonts.items())) + \"\"\"" "$FILE"; \
    done; \
    mkdir -p "$HOME"; \
    chown -R "$USER":"$GROUP" "$HOME"; \
    echo done
