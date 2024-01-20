# Dockerfile for a redis cache

ARG VERSION_TAG

FROM alpine:${VERSION_TAG}

COPY ./tools/entrypoint.sh /usr/local/bin/
RUN <<EOF
chmod +x /usr/local/bin/entrypoint.sh
apk --no-cache add redis
EOF

COPY ./conf/redis.conf /etc/redis.conf

EXPOSE 6379

ENTRYPOINT ["entrypoint.sh"]

CMD ["redis-server", "/etc/redis.conf"]
