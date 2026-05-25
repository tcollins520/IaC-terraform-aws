#!/bin/bash
set -e

echo "============================================================"
echo "STEP-3: Create RetailStore AWS Dataplane using Terraform"
echo "============================================================"
cd 03_AWS_Data_Plane_terraform-manifests
terraform init 
terraform apply -auto-approve

echo
echo "RetailStore AWS Dataplance (RDS MySQL, RDS PostgreSQL, Elasticcache, SQS) creation completed successfully!"
