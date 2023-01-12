#!/bin/bash
set -ex

ZONE=$1
ETCD_IP1=$2
ETCD_IP2=$3
ETCD_IP3=$4
TLS_TYPE=$5
CHART_VERSION=$6
CHART_VERSION=${CHART_VERSION:-0.11.2}
APP_VERSION=$7
APP_VERSION=${APP_VERSION:-2.15.0-alpine} 

# 添加和更新仓库
helm repo add apisix https://charts.apiseven.com
helm repo update

# 备份
date=$(date "+%Y%m%d-%H%M%S")
if [ -d "apisix-ingress-controller" ]; then
    mv apisix apisix.${date}
fi

# 拉取helm chart
helm pull apisix/apisix --untar --version ${CHART_VERSION}

# 修改values.yaml
if [ ${TLS_TYPE} -eq 1 ]; then
    wget https://raw.githubusercontent.com/huweihuang/apisix-yaml/main/helm/apisix/values-tls.yaml -O values.yaml
else
    wget https://raw.githubusercontent.com/huweihuang/apisix-yaml/main/helm/apisix/values.yaml -O values.yaml
fi

sed -i "s|_ZONE_|${ZONE}|;
s|_ETCD_IP1_|${ETCD_IP1}|;
s|_ETCD_IP2_|${ETCD_IP2}|;
s|_ETCD_IP3_|${ETCD_IP3}|;
s|_APP_VERSION_|${APP_VERSION}|" values.yaml

mv values.yaml apisix/values.yaml

# 部署
helm install apisix ./apisix -n ${ZONE}
