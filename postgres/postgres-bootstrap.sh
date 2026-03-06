#!/bin/bash
#
kubectl create namespace postgres

kubectl apply -f ./secret-postgres-statefulset.yaml
kubectl apply -f ./postgres-pvc.yaml 
kubectl apply -f ./postgres-statefulsets.yaml
kubectl apply -f ./postgres-service.yaml

