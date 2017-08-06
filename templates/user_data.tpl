#!/bin/bash

yum install -y aws-cli
aws s3 cp s3://config-${region}/etc/ecs/ecs.config /etc/ecs/ecs.config --region ${region}
echo ECS_CLUSTER='${ecs_cluster_name}' >> /etc/ecs/ecs.config

# Create and set correct permissions for Jenkins mount directory
jenkins_host_dir=/ecs/jenkins-home

mkdir -p $jenkins_host_dir
#chown -R ec2-user:ec2-user $jenkins_host_dir
chmod -R 777 $jenkins_host_dir
