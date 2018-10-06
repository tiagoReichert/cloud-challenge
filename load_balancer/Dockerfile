FROM nginx:1.15.5-alpine

LABEL maintainer="Tiago M Reichert <tiago@reichert.eti.br>"

RUN apk add openssl && rm -rf /var/cache/apk/*
COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENV COMMON_NAME=localhost \
    NODEJS_ADDRESS=app_nodejs

ENTRYPOINT ["/app/entrypoint.sh"]