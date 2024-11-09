# Getting started

eksctl is useful when you want to spin up EKS cluster for testing. The eks-cluster.yaml file contains the configuration for the EKS cluster.
eksctl will automatically create the required VPC and subnets.

Source: https://eksctl.io/usage/vpc-ip-family/

```
# Configure AWS credentials
export AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
export AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>
export AWS_DEFAULT_REGION=eu-west-1

# Check access
aws sts get-caller-identity
{
    "UserId": "AIDA4UZCM7GIVRULV2EJW",
    "Account": "869266160017",
    "Arn": "arn:aws:iam::869266160017:user/marcel"
}

# Install eksctl
brew install eksctl

# Create EKS cluster
eksctl create cluster -f  app-cluster.yaml
````

## Manually scale cluster to 2 nodes

```
eksctl scale nodegroup --name=worker-nodes --cluster app-cluster --nodes=2
```

## Upgrade cluster

```
eksctl upgrade nodegroup --name=worker-nodes --cluster app-cluster
```

# Setup ReadOnly user

For the workshop we have a read-only user that can be used to access the EKS cluster.

First step is to create a clusterrole and clusterrolebinding for the user.

```
❯ kubectl apply -f readonly-user.yaml
clusterrole.rbac.authorization.k8s.io/k8s-read created
clusterrolebinding.rbac.authorization.k8s.io/k8s-read created
```

Add readonly user to the aws-auth configmap

```
on ⛵ app-cluster () conli24-sre-workshop/eksctl on  main [✘»!+] on ☁️  (eu-west-1)
❯ kubectl get -n kube-system configmap/aws-auth -o yaml
apiVersion: v1
data:
  mapRoles: |
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::869266160017:role/eksctl-app-cluster-nodegroup-manag-NodeInstanceRole-Hfc4j8JWgcbH
      username: system:node:{{EC2PrivateDNSName}}
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: arn:aws:iam::869266160017:role/eksctl-app-cluster-nodegroup-worke-NodeInstanceRole-OZSEEMJQrrx6
      username: system:node:{{EC2PrivateDNSName}}
  mapUsers: |
    - groups:
      - k8s-read
      userarn: arn:aws:iam::869266160017:user/k8s-read
      username: k8s-read
kind: ConfigMap
metadata:
  creationTimestamp: "2024-11-01T10:35:44Z"
  name: aws-auth
  namespace: kube-system
  resourceVersion: "2353979"
  uid: a5ab3fbc-d08f-4a49-8389-694b441cc741
```