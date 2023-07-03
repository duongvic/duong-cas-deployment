#!/bin/bash
echo "Deploying system"
kubectl delete -f ../secrets/mariadb.yaml
kubectl create -f ../secrets/mariadb.yaml

kubectl delete -f mail/allinone.yaml
kubectl create -f mail/allinone.yaml

kubectl delete -f auth/mariadb.yaml
kubectl create -f auth/mariadb.yaml
sleep 30
kubectl delete -f auth/allinone.yaml
kubectl create -f auth/allinone.yaml

kubectl delete -f order/mariadb.yaml
kubectl create -f order/mariadb.yaml
sleep 30
kubectl delete -f order/allinone.yaml
kubectl create -f order/allinone.yaml


kubectl delete -f vdc/mariadb.yaml
kubectl create -f vdc/mariadb.yaml
sleep 30
kubectl delete -f vdc/allinone.yaml
kubectl create -f vdc/allinone.yaml


kubectl delete -f dashboard/mariadb.yaml
kubectl create -f dashboard/mariadb.yaml
echo "End deploying system"