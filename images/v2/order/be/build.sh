#!/bin/bash
git clone -b ${BRANCH} https://${GITLAB_AUTH}@git.fptcompute.com.vn/khanhct/cas-order.git

sudo cat  ${REGISTRY_PASS_PATH} | docker login ${REGISTRY} --username ${REGISTRY_USERNAME} --password-stdin
sudo docker build -t ${CAS_ORDER_BE_V2_IMG}:${CAS_VERSION} .

# docker tag SOURCE_IMAGE[:TAG] dev-registry.foxcloud.vn/production/REPOSITORY[:TAG]
sudo docker tag ${CAS_ORDER_BE_V2_IMG}:${CAS_VERSION} ${REGISTRY}/${ENVIRONMENT}/${CAS_ORDER_BE_V2_IMG}:${CAS_VERSION}
sudo docker push ${REGISTRY}/${ENVIRONMENT}/${CAS_ORDER_BE_V2_IMG}:${CAS_VERSION}

rm -rf cas-order
