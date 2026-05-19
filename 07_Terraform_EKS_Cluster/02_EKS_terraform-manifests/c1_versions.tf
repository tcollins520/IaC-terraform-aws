terraform {
  # Minimum Terraform CLI version required
  required_version = ">= 1.12.0"

  # Required providers and version constraints
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }

  # Remote backend configuration using S3 
  backend "s3" {
    bucket         = "tfstate-dev-us-east-1-bl6qlh"         
    key            = "eks/dev/terraform.tfstate"            
    region         = "us-east-1"                            
    encrypt        = true                                   
    use_lockfile   = true     
  }
}

provider "aws" {
  # AWS region to use for all resources (from variables)
  region = var.aws_region
}
