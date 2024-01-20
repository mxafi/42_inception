# Dockerfile for a redis cache

ARG VERSION_TAG

FROM alpine:${VERSION_TAG}

RUN <<EOF
apk --no-cache add redis
ln -sf /proc/1/fd/1 /var/log/redis/redis.log
EOF

COPY ./conf/redis.conf /etc/redis.conf

EXPOSE 6379

ENTRYPOINT ["redis-server", "/etc/redis.conf"]
