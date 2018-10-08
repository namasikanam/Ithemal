#!/usr/bin/env bash

set -ex

AWS_DOCKER_USER="$1"; shift
AWS_DOCKER_PASSWORD="$1"; shift
AWS_DOCKER_ENDPOINT="$1"; shift
MYSQL_USER="$1"; shift
MYSQL_PASSWORD="$1"; shift
MYSQL_HOST="$1"; shift
MYSQL_PORT="$1"; shift

sudo yum install -y docker
sudo service docker start

IMAGE_ID="654586875650.dkr.ecr.us-east-2.amazonaws.com/ithemal:latest"

sudo docker login -u "${AWS_DOCKER_USER}" -p "${AWS_DOCKER_PASSWORD}" "${AWS_DOCKER_ENDPOINT}"
sudo docker pull "${IMAGE_ID}"
sudo docker run -dit --name ithemal -v /home/ec2-user/ithemal:/home/ithemal/ithemal -e ITHEMAL_HOME=/home/ithemal/ithemal "${IMAGE_ID}"
sudo docker exec -u ithemal ithemal bash -lc '/home/ithemal/ithemal/build_all.sh'
sudo docker exec -i -u ithemal ithemal bash -lc 'cat > ~/.my.cnf' <<EOF
[client]
host=${MYSQL_HOST}
port=${MYSQL_PORT}
user=${MYSQL_USER}
password=${MYSQL_PASSWORD}
database=ithemal
EOF
