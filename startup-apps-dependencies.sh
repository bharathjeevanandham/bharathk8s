#/bin/bash

kubectl apply -f ./webapp-3pods.yaml
kubectl apply -f ./config-map.yaml
# kubectl apply -f volume.yaml
# kubectl apply -f volume-pvc.yaml
# kubectl apply -f pod-with-volume.yaml
# kubectl apply -f storageclass-local-path.yaml
kubectl apply -f no-toleration-pod-alpine.yaml
kubectl apply -f secret-mysql-statefulset.yaml
kubectl apply -f mysql-statefulset.yaml
