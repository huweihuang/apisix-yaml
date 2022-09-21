# apisix-yaml

如果采用helm来部署apisix可参考[安装APISIX](https://blog.huweihuang.com/kubernetes-notes/network/gateway/install/)。

本仓库主要是通过yaml文件来部署APISIX。

```
git clone https://github.com/huweihuang/apisix-yaml.git
```

安装

> 需要提前部署etcd并修改etcd配置。

```bash
# apisix
kubectl create -f apisix/apisix.yaml
# 如果要部署为daemonset,则执行以下命令
kubectl create -f apisix/apisix-daemonset.yaml

# apisix-ingress-controller
# apisix crd
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

生成yaml文件

```
helm get manifest apisix-dashboard -n apisix  > apisix-dashboard.yaml
helm get manifest apisix -n apisix > apisix.yaml
helm get manifest apisix-ingress-controller -n apisix > apisix-ingress-controller.yaml
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
