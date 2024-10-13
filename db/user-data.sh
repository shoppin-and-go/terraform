#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user
docker run -d \
    --name mysql \
    -e MYSQL_ROOT_PASSWORD="${root_password}" \
    -e MYSQL_DATABASE="${database}" \
    -e MYSQL_USER="${user}" \
    -e MYSQL_PASSWORD="${password}" \
    -p 3306:3306 \
    -v /var/lib/mysql:/var/lib/mysql \
    mysql:8.0.39