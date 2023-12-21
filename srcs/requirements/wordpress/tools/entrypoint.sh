#!/bin/sh

mv /wp-config.php /var/www/html/wp-config.php

if ! /app/wp core is-installed --path=/var/www/html; then
    echo "Wordpress is not installed, installing it." >> /proc/1/fd/1
    /app/wp core install  --url="<HOST_DOMAIN>" \
                          --title="<SITE_TITLE>" \
                          --admin_user="<ADMIN_USER>" \
                          --admin_password="<ADMIN_PASSWORD>" \
                          --admin_email="<ADMIN_EMAIL>" \
                          --skip-email \
                          --path=/var/www/html \
                          1> /proc/1/fd/1 2> /proc/1/fd/2
fi

chown -R www:www /var/www/html

/usr/sbin/php-fpm82 -F