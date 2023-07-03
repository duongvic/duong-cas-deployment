#!/bin/bash
source ../env.sh
git clone https://github.com/khanhct/cephclient.git
git clone https://github.com/khanhct/shade.git

sudo docker build -t ${CAS_PYTHON_IMG}:${CAS_VERSION} .

# docker tag SOURCE_IMAGE[:TAG] dev-registry.foxcloud.vn/production/REPOSITORY[:TAG]
sudo cat ../registry_password | docker login ${REGISTRY} --username ${REGISTRY_USERNAME} --password-stdin
sudo docker tag ${CAS_PYTHON_IMG}:${CAS_VERSION} ${REGISTRY}/${ENVIRONMENT}/${CAS_PYTHON_IMG}:${CAS_VERSION}
sudo docker push ${REGISTRY}/${ENVIRONMENT}/${CAS_PYTHON_IMG}:${CAS_VERSION}

rm -rf cephclient
rm -rf shade