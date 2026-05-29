terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.20"
    }
  }

  # Remote backend configuration using S3 
  backend "s3" {
    bucket         = "tfstate-dev-us-east-1-bl6qlh"         
    key            = "metrics-server/dev/terraform.tfstate"            
    region         = "us-east-1"                            
    encrypt        = true                                   
    use_lockfile   = true     
  }
}

provider "aws" {
  # AWS region to use for all resources (from variables)
  region = var.aws_region
}
