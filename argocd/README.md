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
```

Source: https://github.com/dash0hq/dash0-operator/blob/main/helm-chart/dash0-operator/README.md#managing-dash0-dashboards

## Perses Dashboards (automatically done via ArgoCD)

Install the Perses dashboard custom resource definition with the following command:

```
kubectl apply --server-side -f https://raw.githubusercontent.com/perses/perses-operator/main/config/crd/bases/perses.dev_persesdashboards.yaml
```

Source: https://github.com/dash0hq/dash0-operator/blob/main/helm-chart/dash0-operator/README.md#managing-dash0-dashboards


## Manually run schema migrations for featureflag service on Postgres

Due to the lack of a proper migration tool, we need to run the schema migrations manually.

```
❯ kubectl exec -it opentelemetry-demo-postgres-postgresql-0 -n otel-demo -- bash

I have no name!@opentelemetry-demo-postgres-postgresql-0:/$ psql -U postgres
Password for user postgres:
psql (16.1)
Type "help" for help.

postgres=# CREATE TABLE IF NOT EXISTS public.featureflags (
postgres(#     name character varying(255),
postgres(#     description character varying(255),
postgres(#     enabled double precision DEFAULT 0.0 NOT NULL
postgres(# );
CREATE TABLE
postgres=# ALTER TABLE ONLY public.featureflags DROP CONSTRAINT IF EXISTS featureflags_pkey;
ALTER TABLE
postgres=# ALTER TABLE ONLY public.featureflags ADD CONSTRAINT featureflags_pkey PRIMARY KEY (name);
ALTER TABLE
postgres=#
postgres=# CREATE UNIQUE INDEX IF NOT EXISTS featureflags_name_index ON public.featureflags USING btree (name);
CREATE INDEX
postgres=# INSERT INTO public.featureflags (name, description, enabled)
postgres-# VALUES
postgres-#     ('productCatalogFailure', 'Fail product catalog service on a specific product', 0),
postgres-#     ('recommendationCache', 'Cache recommendations', 0),
postgres-#     ('adServiceFailure', 'Fail ad service requests', 0),
postgres-#     ('cartServiceFailure', 'Fail cart service requests', 0),
postgres-#     ('paymentServiceSimulateSlowness', 'Simulate slow response times in the payment service', 0),
postgres-#     ('paymentServiceSimulateSlownessLowerBound', 'Minimum simulated delay in milliseconds in payment service, if enabled', 200),
postgres-#     ('paymentServiceSimulateSlownessUpperBound', 'Maximum simulated delay in milliseconds in payment service, if enabled', 600),
postgres-#     ('shippingServiceSimulateSlowness', 'Simulate slow response times in the shipping service', 0),
postgres-#     ('shippingServiceSimulateSlownessLowerBound', 'Minimum simulated delay in milliseconds in shipping service, if enabled', 250),
postgres-#     ('shippingServiceSimulateSlownessUpperBound', 'Maximum simulated delay in milliseconds in shipping service, if enabled', 400)
postgres-#     ON CONFLICT DO NOTHING;
INSERT 0 10
postgres=#
```