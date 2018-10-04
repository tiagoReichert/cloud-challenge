#!/bin/bash

# Specify here the needed parameters:
export SERVICE_NAME='nodejs'
export SMTP_SERVER='smtp.gmail.com'
export SMTP_PORT=587
export SMTP_TLS=True
export SMTP_NAME='CloudChallenge'
export SMTP_USERNAME=''
export SMTP_PASSWORD=''
export SMTP_RECIPIENT=''

# Install dependencies and add Docker repository to apt
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update

# Install Docker community edition
sudo apt-get install -y docker-ce
sudo systemctl enable docker

# Enable swarm mode
sudo docker swarm init

# Deploy swarm service with NodeJS (quantity of replicas is the same as processors available on the host)
sudo docker service create --name nodejs --replicas=$(nproc) --publish 3000:3000 tiagoreichert/cloud-challenge-nodejs:1.0

# Deploy log_parser that will run every day at 22:00
sudo docker service create --name logparser -e SMTP_SERVER=${SMTP_SERVER} -e SMTP_PORT=${SMTP_PORT} \
-e SMTP_TLS=${SMTP_TLS} -e SMTP_NAME=${SMTP_NAME} -e SMTP_USERNAME=${SMTP_USERNAME} -e SMTP_PASSWORD=${SMTP_PASSWORD} \
-e SMTP_RECIPIENT=${SMTP_RECIPIENT} -e SERVICE_NAME=${SERVICE_NAME} -e "TZ=America/Sao_Paulo" \
--mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
--mount type=bind,source=/etc/timezone,target=/etc/timezone:ro tiagoreichert/cloud-challenge-logparser