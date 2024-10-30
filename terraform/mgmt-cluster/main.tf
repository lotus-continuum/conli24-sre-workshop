terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket = "conli24-tf-state"
    key    = "mgmt-cluster"
    region = "eu-west-1"
  }

}

provider "aws" {
  region = "eu-west-1"
}
