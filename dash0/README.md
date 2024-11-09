IMPORTANT:

We are using ArgoCD now to install the dash0-operator. Please refer to the ArgoCD section in the argocd/README.md file.

## Setup Dash0 Operator

```
helm repo add dash0-operator https://dash0hq.github.io/dash0-operator
helm repo update

export DASH0_TOKEN=...

kubectl create namespace dash0-system
kubectl create secret generic dash0-authorization-secret --namespace dash0-system --from-literal=token=${DASH0_TOKEN}

helm install \
  --namespace dash0-system \
  --set operator.dash0Export.enabled=true \
  --set operator.dash0Export.endpoint=ingress.eu-west-1.aws.dash0.com:4317 \
  --set operator.dash0Export.secretRef.name=dash0-authorization-secret \
  --set operator.dash0Export.secretRef.key=token \
  dash0-operator \
  dash0-operator/dash0-operator

kubectl apply -n otel-demo -f - <<EOF
apiVersion: operator.dash0.com/v1alpha1
kind: Dash0Monitoring
metadata:
  name: dash0-monitoring-resource
  namespace: otel-demo
EOF
```

# Cleanup everything

```
❯ helm delete dash0-operator -n dash0-system
release "dash0-operator" uninstalled
```