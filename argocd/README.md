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
