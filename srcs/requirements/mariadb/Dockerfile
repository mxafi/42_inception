# Dockerfile for mariadbLTHCHECK --interval=10s --timeout=8s --start-period=30s --start-interval=5s --retries=3 CMD ["healthcheck.sh"]

ARG VERSION_TAG

FROM alpine:${VERSION_TAG}

ARG DATABASE
ARG USER
ARG PASSWORD
ARG ROOT_PASSWORD

COPY ./conf/mariadb-server.cnf /etc/my.cnf.d/

RUN <<EOF
apk --no-cache add mariadb mariadb-client
/usr/bin/mariadb-install-db --user=mysql --datadir=/var/lib/mysql
mkdir -p /var/log/mysql
touch /var/log/mysql/error.log
chown -R mysql:mysql /var/log/mysql
mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
EOF

COPY ./conf/init.sql /root/
RUN <<EOF
sed -i "s/<DATABASE>/${DATABASE}/g" /root/init.sql
sed -i "s/<USER>/${USER}/g" /root/init.sql
sed -i "s/<PASSWORD>/${PASSWORD}/g" /root/init.sql
sed -i "s/<ROOT_PASSWORD>/${ROOT_PASSWORD}/g" /root/init.sql
EOF

COPY ./tools/entrypoint.sh ./tools/healthcheck.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/healthcheck.sh

EXPOSE 3306

ENTRYPOINT ["entrypoint.sh"]

CMD ["mysqld_safe"]
