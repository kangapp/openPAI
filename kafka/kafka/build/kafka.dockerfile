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

FROM kangapp/hadoop-run


RUN mkdir -p /usr/local/ && \
    wget --no-verbose https://archive.apache.org/dist/kafka/1.1.0/kafka_2.12-1.1.0.tgz -P /usr/local && \
    tar -xzf /usr/local/kafka_2.12-1.1.0.tgz -C /usr/local/ && \
    cd /usr/local && \
    ln -s ./kafka_2.12-1.1.0 kafka && \
    rm /usr/local/kafka_2.12-1.1.0.tgz

ENV KAFKA_HOME=/usr/local/kafka \
    KAFKA_LOG_DIR=/var/lib/kafka-logs \
    KAFKA_CONF_DIR=/usr/local/kafka/config \
    KAFKA_BIN_DIR=/usr/local/kafka/bin

COPY build/start.sh /usr/local/
RUN chmod u+x /usr/local/start.sh

ENV PATH $PATH:/usr/local/kafka/bin
# You could hardcode your configuration in the image. But it's highly recommended to take advantage of k8s to mount your configuration and start script. To make all image stateless, we'd better separate all configuration from the image.

CMD ["/usr/local/start.sh"]
