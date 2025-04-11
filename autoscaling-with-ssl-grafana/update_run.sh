#!/bin/sh
# This script is required to run kafka cluster (without zookeeper)

# Docker workaround: Remove check for KAFKA_ZOOKEEPER_CONNECT parameter
sed -i '/KAFKA_ZOOKEEPER_CONNECT/d' /etc/confluent/docker/configure

# Docker workaround: Ignore cub zk-ready
# sed -i 's/cub zk-ready/echo ignore zk-ready/' /etc/confluent/docker/ensure

# KRaft required step: Format the storage directory with a new cluster ID
echo "export CLUSTER_ID=$(kafka-storage random-uuid)" >> /etc/confluent/docker/bash-config

# Update max message size
# (Needed by TerraformService to store terraform-state files)
sed "s/#max.request.size=/max.request.size=52428800/" -i /etc/kafka/producer.properties