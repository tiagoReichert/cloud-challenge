#!/bin/bash

echo "${CRON_MASK}    /scripts/parser.py" > /etc/crontabs/root

crond -f