#!/bin/bash
set -e

${DENODO_HOME}/configure.sh

startup() {
    echo Starting VQL Server    
    ${DENODO_HOME}/bin/vqlserver_startup.sh
    tail -n +1 -F ${DENODO_HOME}/logs/*/*.log
}

shutdown() {
    echo Stopping VQL Server
    ${DENODO_HOME}/bin/vqlserver_shutdown.sh
}

trap "shutdown" INT
startup