# values.yaml配置修改

- namespaceSelector: ["apisix.ingress=watching"]

- ingressClass: "\_ZONE_"

- serviceNamespace: \_ZONE_

- nodeSelector: {apisix.io/apisix-worker-zone: \_ZONE_}

- resources

# 快速部署apisix 

```bash
wget https://raw.githubusercontent.com/huweihuang/apisix-yaml/main/helm/apisix-ingress-controller/install-ing-controller-by-helm.sh
# etcd without tls
bash install-ing-controller-by-helm <zone>
# 脚本

```bash
sed -i "s|_ZONE_|${ZONE}|" values.yaml
```

# 部署

```bash
# 添加和更新仓库
helm repo add apisix https://charts.apiseven.com
helm repo update
# 拉取helm chart
helm pull apisix/apisix-ingress-controller --untar
# 修改values.yaml

# 安装或升级
helm install apisix-ingress-controller ./apisix-ingress-controller -n apisix
helm upgrade apisix-ingress-controller ./apisix-ingress-controller -n apisix
```
