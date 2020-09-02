#!/bin/bash

set -e
set -x

TITLE=sshtoAWSforWebCam
MAVLINKROUTER_HOME=$HOME/startupscripts
SCRIPT=$MAVLINKROUTER_HOME/start_sshtoAWSforWebCam.sh
LOG=$MAVLINKROUTER_HOME/autostart_sshtoAWSforWebCam.log

# autostart for mavproxy
(
    set -e
    set -x

    date
    set

    export AUTOSSH_GATETIME=0
    export AUTOSSH_LOGLEVEL=7
    export AUTOSSH_POLL=5
    export AUTOSSH_LOGFILE=$MAVLINKROUTER_HOME/autosshtoAWS_forWebCam.log
    cd $MAVLINKROUTER_HOME
    screen -L -d -m -S "$TITLE" -s /bin/bash $SCRIPT
) >$LOG 2>&1
exit 0
