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

I have no name!@opentelemetry-demo-postgres-postgresql-0:/$ psql -U ffs
Password for user ffs:
psql (16.1)
Type "help" for help.

ffs=# CREATE TABLE IF NOT EXISTS public.featureflags (
ffs(#     name character varying(255),
ffs(#     description character varying(255),
ffs(#     enabled double precision DEFAULT 0.0 NOT NULL
ffs(# );
CREATE TABLE
ffs=# ALTER TABLE ONLY public.featureflags DROP CONSTRAINT IF EXISTS featureflags_pkey;
ALTER TABLE
ffs=# ALTER TABLE ONLY public.featureflags ADD CONSTRAINT featureflags_pkey PRIMARY KEY (name);
ALTER TABLE
ffs=#
ffs=# CREATE UNIQUE INDEX IF NOT EXISTS featureflags_name_index ON public.featureflags USING btree (name);
CREATE INDEX
ffs=# INSERT INTO public.featureflags (name, description, enabled)
ffs-# VALUES
ffs-#     ('productCatalogFailure', 'Fail product catalog service on a specific product', 0),
ffs-#     ('recommendationCache', 'Cache recommendations', 0),
ffs-#     ('adServiceFailure', 'Fail ad service requests', 0),
ffs-#     ('cartServiceFailure', 'Fail cart service requests', 0),
ffs-#     ('paymentServiceSimulateSlowness', 'Simulate slow response times in the payment service', 0),
ffs-#     ('paymentServiceSimulateSlownessLowerBound', 'Minimum simulated delay in milliseconds in payment service, if enabled', 200),
ffs-#     ('paymentServiceSimulateSlownessUpperBound', 'Maximum simulated delay in milliseconds in payment service, if enabled', 600),
ffs-#     ('shippingServiceSimulateSlowness', 'Simulate slow response times in the shipping service', 0),
ffs-#     ('shippingServiceSimulateSlownessLowerBound', 'Minimum simulated delay in milliseconds in shipping service, if enabled', 250),
ffs-#     ('shippingServiceSimulateSlownessUpperBound', 'Maximum simulated delay in milliseconds in shipping service, if enabled', 400)
ffs-#     ON CONFLICT DO NOTHING;
INSERT 0 10
ffs=#
```

Manually ran schema migrations

- https://github.com/dash0hq/opentelemetry-demo/blob/main/src/ffspostgres/init-scripts/10-ffs_schema.sql
- https://github.com/dash0hq/opentelemetry-demo/blob/main/src/ffspostgres/init-scripts/20-ffs_data.sql