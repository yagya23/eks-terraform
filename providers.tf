#------------------------------------------------------------------------------
#   Providers
#------------------------------------------------------------------------------

#Terraform version
terraform {
  required_version = "~> 0.15"
}

#Provider versions
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.6.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.50.0"
    }
  }
}

# AWS provider
provider "aws" {
  region = var.region
}
