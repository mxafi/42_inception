# Dockerfile for nginx with a self-signed certificate

ARG ALPINE_PENULTIMATE_VERSION_TAG

FROM alpine:${ALPINE_PENULTIMATE_VERSION_TAG} AS cert-builder
ARG NGINX_HOST_DOMAIN

RUN apk --no-cache add openssl
WORKDIR /cert-build
RUN openssl req -x509 -newkey rsa:4096 -keyout ${NGINX_HOST_DOMAIN}.key -out ${NGINX_HOST_DOMAIN}.crt -sha256 -days 365 -nodes -subj "/CN=${NGINX_HOST_DOMAIN}"

FROM alpine:${ALPINE_PENULTIMATE_VERSION_TAG} AS main-builder
ARG NGINX_HOST_DOMAIN

COPY --from=cert-builder /cert-build /etc/nginx/ssl
COPY ./conf/wordpress.conf /etc/nginx/http.d/wordpress.conf
RUN apk --no-cache add nginx \
    && ln -sf /proc/1/fd/1 /var/log/nginx/access.log \
    && ln -sf /proc/1/fd/2 /var/log/nginx/error.log \
    && sed -i "s/<NGINX_HOST_DOMAIN>/${NGINX_HOST_DOMAIN}/g" /etc/nginx/http.d/wordpress.conf \
    && rm -f /etc/nginx/http.d/default.conf

EXPOSE 443/tcp
EXPOSE 443/udp

CMD ["nginx", "-g", "daemon off;"]
