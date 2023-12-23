# Dockerfile for mariadb

ARG ALPINE_PENULTIMATE_VERSION_TAG

FROM alpine:${ALPINE_PENULTIMATE_VERSION_TAG}

RUN <<EOF
apk --no-cache add mariadb
/usr/bin/mariadb-install-db --user=mysql --datadir=/var/lib/mysql
mkdir -p /var/log/mysql
ln -sf /proc/1/fd/2 /var/log/mysql/error.log
chown -R mysql /var/log/mysql
mkdir -p /run/mysqld
chown mysql /run/mysqld
EOF

COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

EXPOSE 3306

CMD ["mysqld_safe"]
