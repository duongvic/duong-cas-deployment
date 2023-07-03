#!/bin/bash
source ../env.sh
git clone https://github.com/khanhct/cas-order-api.git

sudo cat ../registry_password | docker login ${REGISTRY} --username ${REGISTRY_USERNAME} --password-stdin
sudo docker build -t ${CAS_ORDER_IMG}:${CAS_VERSION} .

# docker tag SOURCE_IMAGE[:TAG] dev-registry.foxcloud.vn/production/REPOSITORY[:TAG]
sudo docker tag ${CAS_ORDER_IMG}:${CAS_VERSION} ${REGISTRY}/${ENVIRONMENT}/${CAS_ORDER_IMG}:${CAS_VERSION}
sudo docker push ${REGISTRY}/${ENVIRONMENT}/${CAS_ORDER_IMG}:${CAS_VERSION}

rm -rf cas-order-api
