#!/bin/bash
set -e

echo "========================================="
echo "STEP-3: Delete RetailStore AWS Dataplane"
echo "========================================="
cd 03_AWS_Data_Plane_terraform-manifests
terraform init
terraform destroy -auto-approve

echo
echo "🧹 Cleaning up local Terraform cache..."
rm -rf .terraform .terraform.lock.hcl

echo
echo "✅ RetailStore AWS Dataplane (RDS MySQL, RDS PostgreSQL, ElastiCache, SQS) destroyed and cleaned up successfully!"
