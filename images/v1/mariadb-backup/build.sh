#!/bin/bash
source ../env.sh

sudo cat ../registry_password | docker login ${REGISTRY} --username ${REGISTRY_USERNAME} --password-stdin
sudo docker build -t ${CAS_DB_BK_IMG}:${CAS_VERSION} .

# docker tag SOURCE_IMAGE[:TAG] dev-registry.foxcloud.vn/production/REPOSITORY[:TAG]
sudo docker tag ${CAS_DB_BK_IMG}:${CAS_VERSION} ${REGISTRY}/${ENVIRONMENT}/${CAS_DB_BK_IMG}:${CAS_VERSION}
sudo docker push ${REGISTRY}/${ENVIRONMENT}/${CAS_DB_BK_IMG}:${CAS_VERSION}
