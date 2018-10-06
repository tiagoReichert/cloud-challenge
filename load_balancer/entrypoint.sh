#!/bin/bash

openssl req -subj "/CN=${COMMON_NAME}" -x509 -newkey rsa:4096 -nodes -keyout /etc/nginx/conf.d/key.pem -out /etc/nginx/conf.d/cert.pem -days 365

# replaces NODEJS_ADDRESS with environment variable on default.conf
sed -i "s/{NODEJS_ADDRESS}/${NODEJS_ADDRESS}/" /etc/nginx/conf.d/default.conf
# replaces NGINX_WORKERS with environment variable on nginx.conf
sed -i "s/{NGINX_WORKERS}/${NGINX_WORKERS}/" /etc/nginx/nginx.conf

nginx -g 'daemon off;'