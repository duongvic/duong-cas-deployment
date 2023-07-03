#!/bin/bash
echo "Deploying system"

kubectl delete -f ../secrets/mariadb.yaml
kubectl create -f ../secrets/mariadb.yaml

kubectl delete -f order/mariadb.yaml
kubectl create -f order/mariadb.yaml
sleep 30
kubectl delete -f order/allinone.yaml
kubectl create -f order/allinone.yaml

echo "End deploying system"