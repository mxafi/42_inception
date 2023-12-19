# Dockerfile for nginx with a self-signed certificate

FROM alpine:${ALPINE_PENULTIMATE_VERSION_TAG} AS cert-builder
RUN apk --no-cache add openssl
WORKDIR /cert-build
RUN openssl req -x509 -newkey rsa:4096 -keyout ${NGINX_HOST}.key -out ${NGINX_HOST}.crt -sha256 -days 365 -nodes -subj "/CN=${NGINX_HOST}"

FROM alpine:${ALPINE_PENULTIMATE_VERSION_TAG} AS main-builder
COPY --from=cert-builder /cert-build /etc/nginx/ssl
RUN apk --no-cache add nginx \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log
