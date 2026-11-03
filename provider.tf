terraform {

  required_version = ">= 1.5"

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

#provider block
provider "aws" {
  region = var.region # reads region from terraform.tfvars
}

# reduce multiple defining of tags
locals {

  common_tags = {

    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
  }
}