# Dockerfile for mariadb

ARG ALPINE_PENULTIMATE_VERSION_TAG

FROM alpine:${ALPINE_PENULTIMATE_VERSION_TAG}

RUN <<EOF
apk --no-cache add mariadb
/usr/bin/mariadb-install-db --user=mysql --datadir=/var/lib/mysql

EOF

EXPOSE 3306

CMD ["mysqld"]