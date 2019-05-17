#!/bin/bash

# Copyright (c) Microsoft Corporation
# All rights reserved.
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
# to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


# Get the configuration from configmap-volume, and cover the original file in the path of hbase's conf
# With this solution, you will be able to use one image to run different role.
cp /kafka-configuration/server.properties $KAFKA_HOME/config/cluster-server.properties


# You could process the un-complete file copied to hbase in your own way.

# example 1
# With the environment passed by kubernetes and docker, fill the target with sed or other tools
sed -i "s/{MASTER_ADDRESS}/${MASTER_ADDRESS}/g" $KAFKA_HOME/config/cluster-server.properties

sed -i "s/{KAFKA_LOG_DIR}/${KAFKA_LOG_DIR}/g" $KAFKA_HOME/config/cluster-server.properties


# example 2
# In our project, we provide a python tool, to fill the target value from the configmap-volume of cluster-configuration. And in this tool, we take advantage of jinja2. You could find more knowledge about jinja2 in this website. http://jinja.pocoo.org/docs/2.10/
# You could find the tool in the code path: src/base-image/build/host-configure.py

## Note: This feature will be upgrade in the future.
## Upgrade reason: 1) To improve the management of service configuration.
## Upgrage reason: 2) To make key-value pair more flexible. Because now, map relation is fixed.
## Upgrade reason: 3) To solve some issue.

HOST_NAME=`hostname`
/usr/local/host-configure.py -c /host-configuration/host-configuration.yaml -f $KAFKA_HOME/config/cluster-server.properties -n $HOST_NAME


