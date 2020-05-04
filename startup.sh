#!/bin/bash
set -e

${DENODO_HOME}/configure.sh

${DENODO_HOME}/bin/vqlserver.sh startup

tail -F ${DENODO_HOME}/logs/*/*.log