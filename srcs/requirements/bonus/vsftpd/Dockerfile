# Dockerfile for vsftpd (FTP server)

ARG VERSION_TAG

FROM alpine:${VERSION_TAG}

ARG FTP_USER
ARG FTP_PASS

COPY ./tools/entrypoint.sh /usr/local/bin/
COPY ./conf/vsftpd.conf ./conf/vsftpd.user_list /etc/vsftpd/
RUN <<EOF
chmod +x /usr/local/bin/entrypoint.sh
apk --no-cache add vsftpd
ln -sf /proc/1/fd/1 /var/log/vsftpd.log
addgroup -S -g 699 ${FTP_USER}
mkdir -p /var/www/html
adduser -S -D -s /bin/sh -h /var/www/html -g "" -u 699 ${FTP_USER} -G ${FTP_USER}
echo "${FTP_USER}:${FTP_PASS}" | chpasswd
sed -i "s/<FTP_USER>/${FTP_USER}/g" /etc/vsftpd/vsftpd.conf
sed -i "s/<FTP_USER>/${FTP_USER}/g" /etc/vsftpd/vsftpd.user_list
chown -R ${FTP_USER} /var/www/html
EOF

EXPOSE 20-21
EXPOSE 30000-30099

ENTRYPOINT ["entrypoint.sh"]

CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]
