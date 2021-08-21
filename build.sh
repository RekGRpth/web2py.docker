#!/bin/sh -eux

DOCKER_BUILDKIT=1 docker build --progress=plain --tag ghcr.io/rekgrpth/web2py.docker . 2>&1 | tee build.log
