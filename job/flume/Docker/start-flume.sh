#!/bin/bash

FLUME_CONF_DIR=/usr/local/conf

[[ -d "${FLUME_CONF_DIR}"  ]] || { echo "flume config file not mounted in /usr/local/conf"; exit 1; }
[[ -z "${FLUME_AGENT_NAME}"  ]] && { echo "FLUME_AGENT_NAME required"; exit 1; }

echo "START FLUME AGENT : ${FLUME_AGENT_NAME}"

flume-ng agent \
        --conf ${FLUME_CONF_DIR} \
        --conf-file ${FLUME_CONF_DIR}/flume.conf \
        --name ${FLUME_AGENT_NAME} \
        -Dflume.root.logger=INFO,console