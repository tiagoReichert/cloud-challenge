FROM nginx:1.15.5-alpine

LABEL maintainer="Tiago M Reichert <tiago@reichert.eti.br>"

RUN apk add openssl bash curl && rm -rf /var/cache/apk/*
COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENV COMMON_NAME=localhost \
    NODEJS_ADDRESS=app_nodejs \
    NGINX_WORKERS=1

HEALTHCHECK --interval=15s --timeout=5s --start-period=15s --retries=3 CMD curl --fail -k https://localhost/ || exit 1

ENTRYPOINT ["/app/entrypoint.sh"]