#!/bin/bash
set -x

zone=$1
cd ${zone}

# apisix
kubectl apply -f apisix/apisix-ds.yaml

# ingress-controller
kubectl create -f apisix-ingress-controller/customresourcedefinitions.yaml
kubectl create -f apisix-ingress-controller/apisix-ingress-controller-rbac.yaml
kubectl apply -f apisix-ingress-controller/apisix-ingress-controller.yaml

# dashboard
kubectl apply -f apisix-dashboard/apisix-dashboard.yaml
