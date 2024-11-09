Add Steadybit Helm repo and deploy the agent chart:

```
helm repo add steadybit https://steadybit.github.io/helm-charts
helm repo update

export STEADYBIT_AGENT_KEY=c480y40ijjdw9z

helm install steadybit-agent --namespace steadybit-agent \
  --create-namespace \
  --set agent.key=${STEADYBIT_AGENT_KEY} \
  -f values.yaml \
  steadybit/steadybit-agent
```
