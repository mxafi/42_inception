#!/bin/sh

lighttpd -f /etc/lighttpd/lighttpd.conf

exec "$@"

