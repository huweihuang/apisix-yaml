#!/bin/bash
set -ex

ZONE=$1
VERSION=$2
VERSION=${VERSION:-0.10.2} # chart version 0.10.2, apisix-ingress-controller verison 1.5.1

# 添加和更新仓库
helm repo add apisix https://charts.apiseven.com
helm repo update

# 备份
date=$(date "+%Y%m%d-%H%M%S")
if [ -d "apisix-ingress-controller" ]; then
    mv apisix-ingress-controller apisix-ingress-controller.${date}
fi
# 拉取helm chart
helm pull apisix/apisix-ingress-controller --untar --version ${VERSION}

# 修改values.yaml
wget https://raw.githubusercontent.com/huweihuang/apisix-yaml/main/helm/apisix-ingress-controller/values.yaml
sed -i "s|_ZONE_|${ZONE}|" values.yaml
mv values.yaml apisix-ingress-controller/values.yaml

# 部署
helm install apisix-ingress-controller ./apisix-ingress-controller -n ${ZONE}
