## Cloud Challenge
This repository contains the source codes for a cloud challenge


#### Management Commands:

Update an existing service
> sudo docker service update --update-parallelism 1 --update-delay 30s nodejs

Rollback the update if needed
> sudo docker service rollback --rollback-parallelism 1 nodejs

Remove service
> sudo docker service remove nodejs
