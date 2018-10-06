#!/bin/bash

openssl req -subj "/CN=${COMMON_NAME}" -x509 -newkey rsa:4096 -nodes -keyout /etc/nginx/conf.d/key.pem -out /etc/nginx/conf.d/cert.pem -days 365

sed -i "s/{NODEJS_ADDRESS}/${NODEJS_ADDRESS}/" /etc/nginx/conf.d/default.conf

nginx -g 'daemon off;'