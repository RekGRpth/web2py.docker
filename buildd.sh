#!/bin/sh -eux

docker build --progress=plain --tag "ghcr.io/rekgrpth/web2py.docker:${INPUTS_BRANCH:-debian}" $(env | grep -E '^DOCKER_' | grep -v ' ' | sort -u | sed 's@^@--build-arg @g' | paste -s -d ' ') --file "${INPUTS_DOCKERFILE:-Dockerfile.debian}" . 2>&1 | tee build.log
