#!/bin/bash
docker exec -it kafka /opt/bitnami/kafka/bin/kafka-topics.sh --create --topic $1 --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
