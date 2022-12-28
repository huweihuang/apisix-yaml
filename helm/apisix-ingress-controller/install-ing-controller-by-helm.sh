#!/bin/bash
set -ex

ZONE=$1

# 添加和更新仓库
helm repo add apisix https://charts.apiseven.com
helm repo update

# 拉取helm chart
mv apisix-ingress-controller apisix-ingress-controller.bak
helm pull apisix/apisix-ingress-controller --untar

# 修改values.yaml
wget https://raw.githubusercontent.com/huweihuang/apisix-yaml/main/helm/apisix-ingress-controller/values.yaml
sed -i "s|_ZONE_|${ZONE}|" values.yaml
mv values.yaml apisix-ingress-controller/values.yaml

# 部署
helm upgrade apisix-ingress-controller ./apisix-ingress-controller -n ${ZONE}
