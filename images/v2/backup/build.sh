#!/bin/bash

export REGISTRY_PASS_PATH=../../registry_password
source ./env.sh

cd ./fe
./build.sh

# TODO(need to test)
# cd ../be
# ./build.sh