#!/bin/bash

export REGISTRY_PASS_PATH=../../registry_password
source ./env.sh

cd fe
./build.sh

cd ../be
./build.sh