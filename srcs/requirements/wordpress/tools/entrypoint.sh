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

    /app/wp user create <EDITOR_USER> <EDITOR_EMAIL> \
                        --role=editor \
                        --user_pass=<EDITOR_PASSWORD> \
                        1> /proc/1/fd/1 2> /proc/1/fd/2

    /app/wp plugin install redis-cache --activate \
        1> /proc/1/fd/1 2> /proc/1/fd/2

    /app/wp plugin update --all \
        1> /proc/1/fd/1 2> /proc/1/fd/2
    
    /app/wp redis enable
fi

chown -R www:www /var/www/html

exec /usr/sbin/php-fpm82 -F
