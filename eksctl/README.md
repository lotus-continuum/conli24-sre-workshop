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