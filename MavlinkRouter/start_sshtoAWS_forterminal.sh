#!/bin/bash

set -e
set -x


autossh -N -R 6000:localhost:22 -i "/home/pi/AWSKEY.pem" ubuntu@AWSIPADDRESS
