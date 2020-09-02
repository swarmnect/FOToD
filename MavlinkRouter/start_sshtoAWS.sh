#!/bin/bash

set -e
set -x

# start mavlink router hopefully /etc/mavlink-router/main.conf loads:

autossh -N -R 1234:localhost:5678 -i "/home/pi/AWSKEY.pem" ubuntu@AWSIPADDRESS

autossh -N -R 6000:localhost:22 -i "/home/pi/AWSKEY.pem" ubuntu@AWSIPADDRESS