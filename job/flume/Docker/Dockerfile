FROM openpai/hadoop-run

ARG FLUME_VERSION=1.8.0

WORKDIR /usr/local

# install Flume
RUN curl -L http://archive.apache.org/dist/flume/${FLUME_VERSION}/apache-flume-${FLUME_VERSION}-bin.tar.gz | tar xz && \
        mv apache-flume-${FLUME_VERSION}-bin apache-flume

COPY start-flume.sh /usr/local/apache-flume/bin/

ENV PATH /usr/local/apache-flume/bin:$PATH

ENTRYPOINT ["/bin/bash","start-flume.sh"]