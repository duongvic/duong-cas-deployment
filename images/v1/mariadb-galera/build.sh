#!/bin/bash
source ../env.sh

sudo docker build -t ${MARIADB_GALERA} .

# docker tag SOURCE_IMAGE[:TAG] dev-registry.foxcloud.vn/production/REPOSITORY[:TAG]
sudo cat ../registry_password | docker login ${REGISTRY} --username ${REGISTRY_USERNAME} --password-stdin
sudo docker tag ${MARIADB_GALERA} ${REGISTRY}/${ENVIRONMENT}/${MARIADB_GALERA}
sudo docker push ${REGISTRY}/${ENVIRONMENT}/${MARIADB_GALERA}
