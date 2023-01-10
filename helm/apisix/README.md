# 快速部署apisix 

```bash
wget https://raw.githubusercontent.com/huweihuang/apisix-yaml/main/helm/apisix/install-apisix-by-helm.sh
bash install-apisix-by-helm.sh <zone> <etcd1_ip> <etcd2_ip> <etcd3_ip>
```

# apisix.values.yaml配置修改

- kind: DaemonSet

- hostNetwork: true

- nodeSelector: {apisix.io/apisix-worker-zone: \_ZONE_}

- plugins:

    - log-rotate

- pluginAttrs:
    ```
    log-rotate:
      interval: 86400
      max_kept: 168
      max_size: -1
      enable_compression: false
    ```
- log
    - accessLog: "/usr/local/apisix/logs/access.log"

    - errorLog: "/usr/local/apisix/logs/error.log"

- configurationSnippet.httpAdmin: 
    ```
    access_log /usr/local/apisix/logs/apisix.admin.access.log;
    error_log /usr/local/apisix/logs/apisix.admin.error.log;
    ```
- etcd:
    - enabled: false
    - host: 修改为已有的etcd节点

# 脚本修改

```bash
sed -i "s|_ZONE_|${ZONE}|;
s|_ETCD_IP1_|${ETCD_IP1}|;
s|_ETCD_IP2_|${ETCD_IP2}|;
s|_ETCD_IP3_|${ETCD_IP3}|" values.yaml
```

# 部署

```bash
# 添加和更新仓库
helm repo add apisix https://charts.apiseven.com
helm repo update
# 拉取helm chart
helm pull apisix/apisix --untar
# 修改values.yaml

# 安装或升级
helm install apisix ./apisix -n apisix
helm upgrade apisix ./apisix -n apisix
```
