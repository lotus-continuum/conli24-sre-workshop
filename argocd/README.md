# Setup ArgoCD

```
helm repo add argo https://argoproj.github.io/argo-helm

kubectl create namespace argocd

helm install argocd argo/argo-cd --namespace argocd

kubectl port-forward service/argocd-server -n argocd 8080:443

kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

kubectl apply -f argocd-demo.yaml
```
