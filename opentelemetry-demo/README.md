# Install OpenTelemetry Demo

https://opentelemetry.io/docs/demo/kubernetes-deployment/

```
❯ helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts

❯ helm install workshop-otel-demo open-telemetry/opentelemetry-demo -f values.yaml -n otel-demo --create-namespace

NAME: workshop-otel-demo
LAST DEPLOYED: Fri Nov  1 11:47:45 2024
NAMESPACE: otel-demo
STATUS: deployed
REVISION: 1
NOTES:
=======================================================================================


 ██████╗ ████████╗███████╗██╗         ██████╗ ███████╗███╗   ███╗ ██████╗
██╔═══██╗╚══██╔══╝██╔════╝██║         ██╔══██╗██╔════╝████╗ ████║██╔═══██╗
██║   ██║   ██║   █████╗  ██║         ██║  ██║█████╗  ██╔████╔██║██║   ██║
██║   ██║   ██║   ██╔══╝  ██║         ██║  ██║██╔══╝  ██║╚██╔╝██║██║   ██║
╚██████╔╝   ██║   ███████╗███████╗    ██████╔╝███████╗██║ ╚═╝ ██║╚██████╔╝
 ╚═════╝    ╚═╝   ╚══════╝╚══════╝    ╚═════╝ ╚══════╝╚═╝     ╚═╝ ╚═════╝


- All services are available via the Frontend proxy: http://localhost:8080
  by running these commands:
     kubectl --namespace default port-forward svc/workshop-otel-demo-frontendproxy 8080:8080

  The following services are available at these paths once the proxy is exposed:
  Webstore             http://localhost:8080/
  Grafana              http://localhost:8080/grafana/
  Load Generator UI    http://localhost:8080/loadgen/
  Jaeger UI            http://localhost:8080/jaeger/ui/
```

## Access Demo

```
❯ kubectl port-forward svc/workshop-otel-demo-frontendproxy 8080:8080 -n otel-demo

Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
Handling connection for 8080
...
```

## Access Applications

- Webstore             http://localhost:8080/
- Grafana              http://localhost:8080/grafana/
- Load Generator UI    http://localhost:8080/loadgen/
- Jaeger UI            http://localhost:8080/jaeger/ui/


# Cleanup everything

```
❯ helm delete workshop-otel-demo -n otel-demo
release "workshop-otel-demo" uninstalled
```
