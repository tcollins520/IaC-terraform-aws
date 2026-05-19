#!/bin/bash
set -e

echo "==============================="
echo "STEP-1: Create VPC using Terraform"
echo "==============================="
cd 01_VPC_terraform-manifests
terraform init 
terraform apply -auto-approve

echo
echo "==============================="
echo "STEP-2: Create EKS Cluster using Terraform"
echo "==============================="
cd ../02_EKS_terraform-manifests
terraform init 
terraform apply -auto-approve

echo
echo "✅ EKS Cluster and VPC creation completed successfully!"
