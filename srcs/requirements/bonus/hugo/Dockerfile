# Dockerfile for Hugo

ARG VERSION_TAG

FROM alpine:${VERSION_TAG}

ARG THEME_NAME=ananke
ARG THEME_LINK=https://github.com/theNewDynamic/gohugo-theme-ananke.git
ARG SITE_TITLE='My Static Site'
ARG SITE_BASEURL='https://example.org/'

COPY ./tools/entrypoint.sh /usr/local/bin/
COPY ./conf/lighttpd.conf /etc/lighttpd/lighttpd.conf


WORKDIR /hugo

RUN <<EOF
chmod +x /usr/local/bin/entrypoint.sh
apk --no-cache add lighttpd rsync git
apk --no-cache add hugo --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
addgroup -S -g 699 www
adduser -S -H -g "" -u 699 www -G www
mkdir -p /run/lighttpd
chown -R www:www /run/lighttpd
hugo new site /hugo
git init
git submodule add ${THEME_LINK} themes/${THEME_NAME}
echo "theme = '${THEME_NAME}'" >> hugo.toml
sed -i "s|^baseURL =.*|baseURL = '${SITE_BASEURL}'|g" hugo.toml
sed -i "s/^title =.*/title = '${SITE_TITLE}'/g" hugo.toml
chown -R www:www .
EOF

USER www

COPY ./content /hugo/content

EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]

CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
