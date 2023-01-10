#!/bin/bash
set -ex

ZONE=$1
ETCD_IP1=$2
ETCD_IP2=$3
ETCD_IP3=$4

# 添加和更新仓库
helm repo add apisix https://charts.apiseven.com
helm repo update

# 拉取helm chart
rm -fr apisix.bak
mv apisix apisix.bak
helm pull apisix/apisix --untar

# 修改values.yaml
wget https://raw.githubusercontent.com/huweihuang/apisix-yaml/main/helm/apisix/values.yaml

sed -i "s|_ZONE_|${ZONE}|;
s|_ETCD_IP1_|${ETCD_IP1}|;
s|_ETCD_IP2_|${ETCD_IP2}|;
s|_ETCD_IP3_|${ETCD_IP3}|" values.yaml

mv values.yaml apisix/values.yaml

# 部署
helm upgrade apisix ./apisix -n ${ZONE}
