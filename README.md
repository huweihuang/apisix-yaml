# apisix-yaml

如果采用helm来部署apisix可参考[安装APISIX](https://blog.huweihuang.com/kubernetes-notes/network/gateway/install/)。

本仓库主要是通过yaml文件来部署APISIX。

```
git clone https://github.com/huweihuang/apisix-yaml.git
```

安装

> 需要提前部署etcd并修改apisix配置。

```bash
# apisix configmap and service
kubectl create -f apisix/apisix-cm.yaml
kubectl create -f apisix/apisix-svc.yaml
# 如果要部署为 daemonset,则执行以下命令
kubectl create -f apisix/apisix-daemonset.yaml
# 如果要部署为 deployment,则执行以下命令
kubectl create -f apisix/apisix-deployment.yaml

# apisix-ingress-controller
# apisix crd
# wget https://raw.githubusercontent.com/apache/apisix-helm-chart/apisix-ingress-controller-0.9.3/charts/apisix-ingress-controller/crds/customresourcedefinitions.yaml
kubectl create -f apisix-ingress-controller/customresourcedefinitions.yaml
# rbac
kubectl create -f apisix-ingress-controller/apisix-ingress-controller-rbac.yaml
# ingress-controller deployment
kubectl create -f apisix-ingress-controller/apisix-ingress-controller.yaml

# apisix-dashborad
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
- Deployment

## apisix-ingress-controller

- ServiceAccount
- RBAC
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
