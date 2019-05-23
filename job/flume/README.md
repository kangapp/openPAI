# Flume In OpenPAI

---  

### 目标

```
实时监控日志目录，通过Flume把新的日志信息保存到HDFS上或对接kafka进行后续操作，需要多个agent协同作业
```

---  

## Flume image

---
目前有两个版本的image，single版本可直接运行，默认版本则要在OpenPAI上运行  
single版本为了让flume Agent在目标机器上运行 => kangapp/flume:single    
默认版本则要对接OpenPAI的服务，例如HDFS,KAFKAd等 => kangapp/flume

---

### 详情

👉 [flume:single传送门](https://github.com/kangapp/openPAI/tree/master/job/flume/Docker)

### Usage
```
#拉取镜像
docker pull kangapp/flume:single  

#运行容器
docker run \
  --env FLUME_AGENT_NAME=docker \
  --volume /conf/config.conf:/usr/local/conf/flume.conf \
  --volume /logs:/usr/local/logs \
  --detach \
  kangapp/flume
```
NOTE:*FLUME_AGENT_NAME*和volume挂载是必须的

## Agent

### avro Agent

> 实时监控日志目录，通过avro sink把日志Event交给下一个Agent处理

#### flume.conf
---
### [taildir-source详情参考](https://flume.apache.org/releases/content/1.9.0/FlumeUserGuide.html#taildir-source)

---
```
docker.sinks = avroSink
docker.sources = taildirSource
docker.channels = memoryChannel

docker.sources.taildirSource.type = TAILDIR
docker.sources.taildirSource.channels = memoryChannel
docker.sources.taildirSource.filegroups = f1
docker.sources.taildirSource.filegroups.f1 = /usr/local/logs/.*

docker.channels.memoryChannel.type = memory
docker.channels.memoryChannel.capacity = 1000
docker.channels.memoryChannel.transactionCapacity = 100

docker.sinks.avroSink.type = avro
docker.sinks.avroSink.hostname = 10.46.178.107
docker.sinks.avroSink.port = 4141
docker.sinks.avroSink.channel = memoryChannel
```

### kafka Agent

> 对接上一个Agent，消息对接kafka

#### flume.conf
---
### [kafka-sink详情参考](https://flume.apache.org/releases/content/1.9.0/FlumeUserGuide.html#kafka-sink)

---
```
docker.sinks = kafkaSink
docker.sources = avroSource
docker.channels = memoryChannel

docker.sources.avroSource.type = avro
docker.sources.avroSource.bind = 0.0.0.0
docker.sources.avroSource.port = 4141
docker.sources.avroSource.channels = memoryChannel

docker.channels.memoryChannel.type = memory
docker.channels.memoryChannel.capacity = 1000
docker.channels.memoryChannel.transactionCapacity = 100

docker.sinks.kafkaSink.type = org.apache.flume.sink.kafka.KafkaSink
docker.sinks.kafkaSink.topic = flume_kafka
docker.sinks.kafkaSink.brokerList = 10.46.28.140:9092,10.46.179.174:9092,10.46.178.107:9092
docker.sinks.kafkaSink.requiredAcks = 1
docker.sinks.kafkaSink.batchSize = 10
docker.sinks.kafkaSink.channel = memoryChannel
```