#!/bin/bash
set -ex

ZONE=$1

CHART_VERSION=$2
CHART_VERSION=${CHART_VERSION:-0.11.3}

APP_VERSION=$3
APP_VERSION=${APP_VERSION:-1.6.0} 

# 添加和更新仓库
helm repo add apisix https://charts.apiseven.com
helm repo update

# 备份
date=$(date "+%Y%m%d-%H%M%S")
if [ -d "apisix-ingress-controller" ]; then
    mv apisix-ingress-controller apisix-ingress-controller.${date}
fi
# 拉取helm chart
helm pull apisix/apisix-ingress-controller --untar --version ${CHART_VERSION}

# 修改values.yaml
wget https://raw.githubusercontent.com/huweihuang/apisix-yaml/main/helm/apisix-ingress-controller/values.yaml
sed -i "s|_ZONE_|${ZONE}|;
s|_APP_VERSION_|${APP_VERSION}|" values.yaml
mv values.yaml apisix-ingress-controller/values.yaml

# 部署
helm install apisix-ingress-controller ./apisix-ingress-controller -n ${ZONE}
