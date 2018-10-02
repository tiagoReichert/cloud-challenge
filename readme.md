## Cloud Challenge
This repository contains the source codes for a cloud challenge


#### Management Commands:

Update an existing service
> sudo docker service update --update-parallelism 1 --update-order start-first
--update-delay 30s --update-failure-action=rollback --image tiagoreichert/cloud-challenge:2.0 nodejs

Rollback the update if wanted
> sudo docker service rollback nodejs

Remove service
> sudo docker service remove nodejs
