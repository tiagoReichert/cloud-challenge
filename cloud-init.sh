#!/bin/bash

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

# Enable swarm mode
sudo docker swarm init

# Deploy swarm service with NodeJS (quantity of replicas is the same as processors available on the host)
sudo docker service create --name nodejs --replicas=$(nproc) --publish 3000:3000 tiagoreichert/cloud-challenge:1.0


