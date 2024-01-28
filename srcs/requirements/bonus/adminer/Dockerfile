# Dockerfile for Adminer

ARG VERSION_TAG

FROM alpine:${VERSION_TAG}

ARG ADMINER_LINK=https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1-en.php

COPY ./tools/entrypoint.sh /usr/local/bin/
COPY ./conf/lighttpd.conf /etc/lighttpd/lighttpd.conf

ADD ${ADMINER_LINK} /var/www/html/index.php

RUN <<EOF
chmod +x /usr/local/bin/entrypoint.sh
apk --no-cache add php82 php82-cgi php82-session php82-mysqli lighttpd
ln -sf /usr/bin/php-cgi82 /usr/bin/php-cgi
addgroup -S -g 699 www
adduser -S -H -g "" -u 699 www -G www
mkdir -p /var/www/html
chown -R www:www /var/www/html
mkdir -p /run/lighttpd
chown -R www:www /run/lighttpd
EOF

EXPOSE 80

USER www

ENTRYPOINT ["entrypoint.sh"]

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
