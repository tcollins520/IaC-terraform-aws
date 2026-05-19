#!/bin/bash
set -e

echo "==============================="
echo "STEP-1: Destroy EKS Cluster"
echo "==============================="
cd 02_EKS_terraform-manifests
terraform destroy -auto-approve

echo
echo "🧹 Cleaning up local Terraform cache..."
rm -rf .terraform .terraform.lock.hcl

echo
echo "==============================="
echo "STEP-2: Destroy VPC"
echo "==============================="
cd ../01_VPC_terraform-manifests
terraform destroy -auto-approve

echo
echo "🧹 Cleaning up local Terraform cache..."
rm -rf .terraform .terraform.lock.hcl

echo
echo "✅ EKS Cluster and VPC destroyed and cleaned up successfully!"
