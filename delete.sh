#!/bin/bash
set -ex

zone=$1
cd ${zone}

# apisix
kubectl delete -f apisix/apisix-ds.yaml

# ingress-controller
kubectl delete -f apisix-ingress-controller/apisix-ingress-controller.yaml

# dashboard
kubectl delete -f apisix-dashboard/apisix-dashboard.yaml
