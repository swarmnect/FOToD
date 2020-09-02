#!/bin/bash

set -e
set -x


# For webcam, we want to forward local port 8080 on AWS to port 80 on RPi0W.

# Local URL is 192.168.1.xxx/html/index.php


autossh  -N -R 8080:localhost:80 -i "/home/pi/awskey.pem" ubuntu@AWSIPADDRESS

