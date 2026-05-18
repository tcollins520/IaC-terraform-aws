variable "environment_name" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy backend (e.g., us-west-2)"
  type        = string
  default     = "us-east-1"
}
