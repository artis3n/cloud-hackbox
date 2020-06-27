#!/bin/env bash
set -ex

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 2222") \
&& INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id) \
&& aws --region us-east-1 ec2 reboot-instances --instance-ids "${INSTANCE_ID}"
