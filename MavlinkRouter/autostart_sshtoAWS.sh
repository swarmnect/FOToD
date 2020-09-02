#!/bin/bash

set -e
set -x

TITLE=sshtoAWS
MAVLINKROUTER_HOME=$HOME/startupscripts
SCRIPT=$MAVLINKROUTER_HOME/start_sshtoAWS.sh
LOG=$MAVLINKROUTER_HOME/autostart_sshtoAWS.log

# autostart for mavproxy
(
    set -e
    set -x

    date
    set

    cd $MAVLINKROUTER_HOME
    export AUTOSSH_GATETIME=0
    export AUTOSSH_LOGLEVEL=7
    export AUTOSSH_POLL=5
    export AUTOSSH_LOGFILE=$MAVLINKROUTER_HOME/autosshtoAWS.log
    screen -L -d -m -S "$TITLE" -s /bin/bash $SCRIPT
) >$LOG 2>&1
exit 0
