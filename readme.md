[![MIT License](http://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE) [![Dockerhub](http://img.shields.io/badge/dockerhub-NodeJS-blue.svg?style=flat)](https://hub.docker.com/r/tiagoreichert/cloud-challenge-nodejs/) [![Dockerhub](http://img.shields.io/badge/dockerhub-LogParser-blue.svg?style=flat)](https://hub.docker.com/r/tiagoreichert/cloud-challenge-logparser/)  [![Dockerhub](http://img.shields.io/badge/dockerhub-Nginx-blue.svg?style=flat)](https://hub.docker.com/r/tiagoreichert/cloud-challenge-nginx/)  [![Dockerhub](http://img.shields.io/badge/dockerhub-ThroughputAnalyzer-blue.svg?style=flat)](https://hub.docker.com/r/tiagoreichert/cloud-challenge-analyzer/)

## Cloud Challenge
This repository contains the source codes for a cloud challenge.

### How to deploy:

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
4. Run the script (this will install all dependencies and start nodejs, nginx and logparser)
```console
chmod +x cloud-init.sh && ./cloud-init.sh
```

5. Just wait until all containers are started
```console
sudo docker service ls
```

Now you should already be able to access your application over HTTP and HTTPS.
If you specified valid SMTP variables, you will also receive the emails from log_parser on the time period defined with the cron mask.

### Throughput Analyzer
To analyze the throughput supported by the application the script [analyzer.py](throughput/analyzer.py)
was developed, to run it you will need to specify following parameters:

- URL : The url to which the script should do requests;
- SECONDS : The maximum time that the script should run;
- THREADS: The quantity of threads that should be started to run the script.

The quantity of requests per second may vary to the resources available for the script to run (CPU and network are the biggest bottlenecks).

##### Running with Docker:
You will need to specify an address from which the container can access the application
```console
reichert@ubuntu:~$ sudo docker run --rm -e URL=https://172.16.111.129 -e THREADS=2 -e SECONDS=10 tiagoreichert/cloud-challenge-analyzer
4373 requests during 0:00:10.001029 [437 req/s]
```

##### Running without Docker:
You can also run the script directly using Python 2:
```console
reichert@ubuntu:~$ curl -O https://raw.githubusercontent.com/tiagoReichert/cloud-challenge/master/throughput/analyzer.py
reichert@ubuntu:~$ python analyzer.py --threads 2 --seconds 10 --url https://127.0.0.1
4412 requests during 0:00:10.006118 [441 req/s]
```

### Management Commands:
For further management of the application you will need to use following commands

Check the status of the existing services
```console
sudo docker service ls
```
Update an existing service
```console
sudo docker service update --update-parallelism 1 --update-order start-first --update-delay 10s --update-failure-action=rollback --image tiagoreichert/cloud-challenge-nodejs:2.0 app_nodejs
```
Rollback the update if wanted
```console
sudo docker service rollback app_nodejs
```
Remove stack
```console
sudo docker stack rm app
```
Scale the service up or down
```console
sudo docker service scale app_nodejs=3
```
Check service logs
```console
sudo docker service logs app_nodejs
```

### Additional comments:
 I did not use any infrastructure automation software (like Ansible), because in this case it was not needed
(the deploy is simple enough like it is). If this software would be deployed for production,
some changes would need to be done, however, this would require more hosts, and for this challenge I should use only one host.

Some things that could be improved are:

- Setup a cluster for containers ([Rancher](https://rancher.com/) is a good way to go)
- Create monitoring of the applications ([Prometheus](https://prometheus.io/) + [Grafana](https://grafana.com/))
- Use [ELK](https://www.elastic.co/elk-stack) instead of this [log parser](log_parser/parser.py) script to extract meaningful information from logs.
- Use signed certificates for HTTPS ([Let's Encrypt](https://letsencrypt.org/) is a free solution for dev/test environments)
- Among others...
