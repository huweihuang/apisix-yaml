#!/bin/bash
set -ex

ZONE=$1
ETCD_IP1=$2
ETCD_IP2=$3
ETCD_IP3=$4
CHART_VERSION=$5
CHART_VERSION=${CHART_VERSION:-0.7.0}

APP_VERSION=$6
APP_VERSION=${APP_VERSION:-2.15.0-alpine} 

# 添加和更新仓库 
helm repo add apisix https://charts.apiseven.com
helm repo update apisix

# 备份
date=$(date "+%Y%m%d-%H%M%S")
if [ -d "apisix-dashboard" ]; then
    mv apisix-dashboard apisix-dashboard.${date}
fi
# 拉取helm chart
helm pull apisix/apisix-dashboard --untar --version ${CHART_VERSION}

# 修改values.yaml
wget https://raw.githubusercontent.com/huweihuang/apisix-yaml/main/helm/apisix-dashboard/values.yaml

sed -i "s|_ZONE_|${ZONE}|;
s|_ETCD_IP1_|${ETCD_IP1}|;
s|_ETCD_IP2_|${ETCD_IP2}|;
s|_ETCD_IP3_|${ETCD_IP3}|;
s|_APP_VERSION_|${APP_VERSION}|" values.yaml

mv values.yaml apisix-dashboard/values.yaml

# 部署
helm install apisix-dashboard ./apisix-dashboard -n ${ZONE}
