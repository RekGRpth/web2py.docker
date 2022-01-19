#!/bin/sh -eux

addgroup --system "$GROUP"
adduser --system --disabled-password --home "$HOME" --shell /sbin/nologin --ingroup "$GROUP" "$USER"
