# apisix-yaml

如果采用helm来部署apisix可参考[安装APISIX](https://blog.huweihuang.com/kubernetes-notes/network/gateway/install/)。

helm部署脚本参考 [helm](helm)

本仓库主要是通过yaml文件来部署APISIX。

```
git clone https://github.com/huweihuang/apisix-yaml.git
```

# 部署

## 需要提前部署etcd并修改apisix配置

```bash
bash gen-apisix-yaml.sh -z <zone> -a <etcd_ip1> -b <etcd_ip2> -c <etcd_ip3>
```

## 部署apisix套件

### apisix

```bash
# 如果要部署为 daemonset,则执行以下命令
kubectl create -f apisix/apisix-ds.yaml
# 如果要部署为 deployment,则执行以下命令
kubectl create -f apisix/apisix-deployment.yaml
```

### apisix-ingress-controller

```bash
# apisix crd
# wget https://raw.githubusercontent.com/apache/apisix-helm-chart/apisix-ingress-controller-0.9.3/charts/apisix-ingress-controller/crds/customresourcedefinitions.yaml
kubectl create -f apisix-ingress-controller/customresourcedefinitions.yaml
# rbac
kubectl create -f apisix-ingress-controller/apisix-ingress-controller-rbac.yaml
# ingress-controller deployment
kubectl create -f apisix-ingress-controller/apisix-ingress-controller.yaml
```

如果要在同一个k8s集群中部署多套ingress-controller，则需要创建新的ServiceAccount。

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: apisix-ingress-controller
  namespace: _ZONE2_
automountServiceAccountToken: true
```

并修改apisix-ingress-controller-clusterrolebinding，添加ServiceAccount。

```
kubectl edit ClusterRoleBinding apisix-ingress-controller-clusterrolebinding
```

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: apisix-ingress-controller-clusterrolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: apisix-ingress-controller-clusterrole
subjects:
  - kind: ServiceAccount
    name: apisix-ingress-controller
    namespace: _ZONE_
  - kind: ServiceAccount
    name: apisix-ingress-controller
    namespace: _ZONE2_
```

### apisix-dashborad

```bash
kubectl create -f apisix-dashboard/apisix-dashboard.yaml
```

# helm生成yaml

apisix k8s yaml文件源于 https://github.com/apache/apisix-helm-chart 仓库，执行helm命令获取的yaml内容。

查看helm列表

```
helm list -A
```

## 生成yaml文件

```
helm get manifest apisix-dashboard -n apisix  > apisix-dashboard.yaml
helm get manifest apisix -n apisix > apisix.yaml
helm get manifest apisix-ingress-controller -n apisix > apisix-ingress-controller.yaml
```

## helm生成CRD文件

有两种方式查看CRD文件。

1、从git仓库上下载

登录 https://github.com/apache/apisix-helm-chart ，选择版本tag，查看apisix-ingress-controller/crds/customresourcedefinitions.yaml

```
wget https://raw.githubusercontent.com/apache/apisix-helm-chart/apisix-ingress-controller-0.9.3/charts/apisix-ingress-controller/crds/customresourcedefinitions.yaml
```

2、下载helm文件

```bash
# 下载apisix/apisix-ingress-controller
helm fetch apisix/apisix-ingress-controller
# 解压
tar -zvxf apisix-ingress-controller-0.9.3.tgz
# 查看crd文件
ll apisix-ingress-controller/crds/customresourcedefinitions.yaml
```

# apisix k8s object

## apisix

- ConfigMap
- Service
- Deployment(Daemonset)

## apisix-ingress-controller

- RBAC
  - ServiceAccount (namespace级别)
  - ClusterRole (cluster级别)
  - ClusterRoleBinding (cluster级别：可绑定多个ServiceAccount)
- ConfigMap
- Service
- Deployment
- CRD
  - apisixclusterconfigs.apisix.apache.org
  - apisixconsumers.apisix.apache.org
  - apisixpluginconfigs.apisix.apache.org
  - apisixroutes.apisix.apache.org
  - apisixtlses.apisix.apache.org
  - apisixupstreams.apisix.apache.org

## apisix-dashboard

- ServiceAccount
- ConfigMap
- Service
- Deployment
