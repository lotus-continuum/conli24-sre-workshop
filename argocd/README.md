# Setup ArgoCD using Helm

```
helm repo add argo https://argoproj.github.io/argo-helm
kubectl create namespace argocd
helm install argocd argo/argo-cd --namespace argocd
```

Access ArgoCD via port forwarding:

```
kubectl port-forward service/argocd-server -n argocd 8080:443

# get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Install ArgoCD Applications

```
kubectl apply -f argocd-demo.yaml
kubectl apply -f argocd-monitoring.yaml
```

## Prometheus Alerts (automatically done via ArgoCD)

```
❯ kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.78.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml

customresourcedefinition.apiextensions.k8s.io/prometheusrules.monitoring.coreos.com serverside-applied
``

Source: https://github.com/dash0hq/dash0-operator/blob/main/helm-chart/dash0-operator/README.md#managing-dash0-dashboards

## Perses Dashboards (automatically done via ArgoCD)

Install the Perses dashboard custom resource definition with the following command:

```
kubectl apply --server-side -f https://raw.githubusercontent.com/perses/perses-operator/main/config/crd/bases/perses.dev_persesdashboards.yaml
```

Source: https://github.com/dash0hq/dash0-operator/blob/main/helm-chart/dash0-operator/README.md#managing-dash0-dashboards