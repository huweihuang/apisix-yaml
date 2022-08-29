# apisix-yaml

通过yaml文件来部署

```
git clone https://github.com/huweihuang/apisix-yaml.git
```

安装

> 需要提前部署etcd并修改etcd配置。

```
kubectl create -f apisix/apisix.yaml
```

# helm生成yaml

apisix k8s yaml文件源于https://github.com/apache/apisix-helm-chart仓库，执行helm命令获取的yaml内容。

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

## apisix-dashboard

- ServiceAccount
- ConfigMap
- Service
- Deployment
