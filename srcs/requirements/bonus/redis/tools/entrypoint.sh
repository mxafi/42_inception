#!/bin/sh

ln -sf /proc/1/fd/1 /var/log/redis/redis.log

exec "$@"
