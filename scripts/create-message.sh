docker exec -it kafka /opt/bitnami/kafka/bin/kafka-console-producer.sh --topic $1 --bootstrap-server localhost:9092
