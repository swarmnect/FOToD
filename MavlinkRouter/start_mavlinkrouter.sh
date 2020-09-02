#!/bin/bash

set -e
set -x

# start mavlink router 
# it will use /etc/mavlink-router/main.conf as its configuration

/home/pi/mavlink-router/mavlink-routerd
