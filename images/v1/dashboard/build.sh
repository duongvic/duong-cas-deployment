#!/bin/bash
source ../env.sh
# docker builder prune
git clone https://git.fptcompute.com.vn/portal/cas-fe.git

sudo cat ../registry_password | docker login ${REGISTRY} --username ${REGISTRY_USERNAME} --password-stdin
sudo docker build -t ${CAS_DASHBOARD_IMG}:${CAS_VERSION} .

# docker tag SOURCE_IMAGE[:TAG] dev-registry.foxcloud.vn/production/REPOSITORY[:TAG]
sudo docker tag ${CAS_DASHBOARD_IMG}:${CAS_VERSION} ${REGISTRY}/${ENVIRONMENT}/${CAS_DASHBOARD_IMG}:${CAS_VERSION}
sudo docker push ${REGISTRY}/${ENVIRONMENT}/${CAS_DASHBOARD_IMG}:${CAS_VERSION}

rm -rf cas-fe
