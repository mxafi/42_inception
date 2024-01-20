# Dockerfile for vsftpd (FTP server)

ARG VERSION_TAG

FROM alpine:${VERSION_TAG}

COPY ./tools/entrypoint.sh /usr/local/bin/
RUN <<EOF
chmod +x /usr/local/bin/entrypoint.sh
apk --no-cache add vsftpd
ln -sf /proc/1/fd/1 /var/log/vsftpd.log
EOF

COPY ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

EXPOSE 21
EXPOSE 20

ENTRYPOINT ["entrypoint.sh"]

CMD ["vsftpd", "/etc/vsftpd/vsftpd.conf"]
