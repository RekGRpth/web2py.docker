#!/bin/sh -eux

addgroup -S "$GROUP"
adduser -S -D -G "$GROUP" -H -h "$HOME" -s /sbin/nologin "$USER"
