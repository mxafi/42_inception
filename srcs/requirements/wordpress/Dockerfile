# Dockerfile for wordpress with php-fpm

ARG ALPINE_PENULTIMATE_VERSION_TAG

FROM alpine:${ALPINE_PENULTIMATE_VERSION_TAG}

ARG HOST_DOMAIN
ARG DB_HOST
ARG DB_NAME
ARG DB_USER
ARG DB_PASSWORD
ARG SITE_TITLE
ARG ADMIN_USER
ARG ADMIN_PASSWORD
ARG ADMIN_EMAIL

WORKDIR /var/www/html

COPY ./conf/wp-config.php /wp-config.php
COPY ./tools/entrypoint.sh /entrypoint.sh

RUN <<EOF
apk --no-cache add php82 php82-fpm php82-mysqli php82-mbstring curl libcurl php82-curl libzip php82-zip php82-phar
sed -i "s/<DB_HOST>/${DB_HOST}/g" /wp-config.php
sed -i "s/<DB_NAME>/${DB_NAME}/g" /wp-config.php
sed -i "s/<DB_USER>/${DB_USER}/g" /wp-config.php
sed -i "s/<DB_PASSWORD>/${DB_PASSWORD}/g" /wp-config.php
ln -sf /proc/1/fd/1 /var/log/php82/error.log
addgroup -S -g 699 www
adduser -S -H -g "" -u 699 www -G www
sed -i "s/user = nobody/user = www/g" /etc/php82/php-fpm.d/www.conf
sed -i "s/group = nobody/group = www/g" /etc/php82/php-fpm.d/www.conf
sed -i "s/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g" /etc/php82/php-fpm.d/www.conf
sed -i "s/;listen.owner = nobody/listen.owner = www/g" /etc/php82/php-fpm.d/www.conf
echo "cgi.fix_pathinfo=0" >> /etc/php82/php.ini
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
ln -sf /usr/bin/php82 /usr/bin/php
chmod +x wp-cli.phar
mkdir /app
mv wp-cli.phar /app/wp
/app/wp core download --path=/var/www/html
sed -i "s/<HOST_DOMAIN>/${HOST_DOMAIN}/g" /entrypoint.sh
sed -i "s/<SITE_TITLE>/${SITE_TITLE}/g" /entrypoint.sh
sed -i "s/<ADMIN_USER>/${ADMIN_USER}/g" /entrypoint.sh
sed -i "s/<ADMIN_PASSWORD>/${ADMIN_PASSWORD}/g" /entrypoint.sh
sed -i "s/<ADMIN_EMAIL>/${ADMIN_EMAIL}/g" /entrypoint.sh
chmod +x /entrypoint.sh
EOF

EXPOSE 9000

CMD ["/entrypoint.sh"]
