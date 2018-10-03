[![MIT License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE) [![Dockerhub](http://img.shields.io/badge/dockerhub-NodeJS-blue.svg?style=flat)](https://hub.docker.com/r/tiagoreichert/cloud-challenge-nodejs/) [![Dockerhub](http://img.shields.io/badge/dockerhub-LogParser-blue.svg?style=flat)](https://hub.docker.com/r/tiagoreichert/cloud-challenge-logparser/) 

## Cloud Challenge
This repository contains the source codes for a cloud challenge.

#### How to deploy:

You can just add the missing environment variables at the begging of the cloud-init.sh
script and use it as cloud-init script for a new virtual machine using Ubuntu 16.04 LTS.

If you don't know how to do that you can also perform following manual steps:

1. Setup an host with Ubuntu 16.04 LTS
2. Download the cloud-init.sh script to the host
```console
sudo apt-get update && sudo apt-get install -y curl
curl https://raw.githubusercontent.com/tiagoReichert/cloud-challenge/master/cloud-init.sh -O
```
3. Inform the missing environment variables on the beginning of the file (for email authentication)
```console
vi cloud-init.sh
```
4. Run the script (this will install all dependencies and start nodejs and logparser)
```console
chmod +x cloud-init.sh && ./cloud-init.sh
```

#### Management Commands:
For further managament of the application you will need to use following commands

Update an existing service
> sudo docker service update --update-parallelism 1 --update-order start-first
--update-delay 10s --update-failure-action=rollback --image tiagoreichert/cloud-challenge-nodejs:2.0 nodejs

Rollback the update if wanted
> sudo docker service rollback nodejs

Remove service
> sudo docker service remove nodejs

Scale the service up or down
> sudo docker service scale nodejs=3

Check service logs
> sudo docker service logs nodejs
