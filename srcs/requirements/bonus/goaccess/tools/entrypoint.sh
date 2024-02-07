#!/bin/sh

FILE=/var/log/nginx/access.log
while [ ! -f "$FILE" ]; do
  echo "$FILE does not exist. Sleeping for a minute."
  sleep 60
done

echo "$FILE found, starting goaccess!"

lighttpd -f /etc/lighttpd/lighttpd.conf

exec "$@"

