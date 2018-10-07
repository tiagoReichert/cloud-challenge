#!/bin/bash

# Specify here the needed/missing parameters:
# Do not use passwords or email addresses containing /
export SMTP_SERVER='smtp.gmail.com'
export SMTP_PORT=587
export SMTP_TLS=True
export SMTP_NAME='CloudChallenge'
export SMTP_USERNAME=''
export SMTP_PASSWORD=''
export SMTP_RECIPIENT=''
export NODEJS_REPLICAS=$(nproc)
export NGINX_WORKERS=1
export LOGPARSER_CRON_MASK='00  22  *  *  *'

# Install dependencies and add Docker repository to apt
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update

# Install Docker community edition and enable to start automatically
sudo apt-get install -y docker-ce
sudo systemctl enable docker

# Enable swarm mode
sudo docker swarm init

# Download docker-compose
curl -O https://raw.githubusercontent.com/tiagoReichert/cloud-challenge/master/docker-compose.yml

# Replace environment variables on docker-compose (this because docker swarm does not support docker-compose with environment variables)
sed -i "s/{SMTP_SERVER}/${SMTP_SERVER}/" ./docker-compose.yml
sed -i "s/{SMTP_PORT}/${SMTP_PORT}/" ./docker-compose.yml
sed -i "s/{SMTP_TLS}/${SMTP_TLS}/" ./docker-compose.yml
sed -i "s/{SMTP_NAME}/${SMTP_NAME}/" ./docker-compose.yml
sed -i "s/{SMTP_USERNAME}/${SMTP_USERNAME}/" ./docker-compose.yml
sed -i "s/{SMTP_PASSWORD}/${SMTP_PASSWORD}/" ./docker-compose.yml
sed -i "s/{SMTP_RECIPIENT}/${SMTP_RECIPIENT}/" ./docker-compose.yml
sed -i "s/{NODEJS_REPLICAS}/${NODEJS_REPLICAS}/" ./docker-compose.yml
sed -i "s/{NGINX_WORKERS}/${NGINX_WORKERS}/" ./docker-compose.yml
sed -i "s@{CRON_MASK}@${LOGPARSER_CRON_MASK}@" ./docker-compose.yml

# Start the stack with NodeJS, Nginx and LogParser
sudo docker stack deploy --compose-file docker-compose.yml app
