# Dockerfile for GoAccess

ARG VERSION_TAG

FROM alpine:${VERSION_TAG} as builder

ARG GOACCESS_TARFILE=goaccess-1.9.tar.gz

WORKDIR /goaccess
ADD https://tar.goaccess.io/${GOACCESS_TARFILE} /goaccess/${GOACCESS_TARFILE}

RUN apk add --no-cache \
    autoconf \
    automake \
    build-base \
    clang \
    clang-static \
    gettext-dev \
    gettext-static \
    git \
    libmaxminddb-dev \
    libmaxminddb-static \
    libressl-dev \
    linux-headers \
    ncurses-dev \
    ncurses-static \
    tzdata

RUN <<EOF
tar -xzvf ${GOACCESS_TARFILE}
cd $(echo ${GOACCESS_TARFILE} | cut -f1,2 -d".")
autoreconf -fiv
CC="clang" CFLAGS="-O3 -static" LIBS="$(pkg-config --libs openssl)" ./configure --prefix="" --enable-utf8 --with-openssl --enable-geoip=mmdb
make
make DESTDIR=/dist install
EOF

FROM alpine:${VERSION_TAG}

COPY --from=builder /dist /
COPY ./tools/entrypoint.sh /usr/local/bin/
COPY ./conf/lighttpd.conf /etc/lighttpd/lighttpd.conf

RUN <<EOF
chmod +x /usr/local/bin/entrypoint.sh
apk --no-cache add lighttpd 
mkdir -p /run/lighttpd
mkdir -p /var/www/html
EOF

EXPOSE 80

ENTRYPOINT ["entrypoint.sh"]
CMD ["goaccess", "/var/log/nginx/access.log", "--log-format=COMBINED", "-o", "/var/www/html/report.html", "--real-time-html"]

