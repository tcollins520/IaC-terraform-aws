################################################################################
# EKS Pod Identity Association - Orders PostgreSQL
################################################################################

# This Pod Identity Association allows the Orders microservice (running as 
# ServiceAccount `orders`) to assume the IAM role that has access to 
# AWS Secrets Manager.
#
# Purpose:
# - The IAM Role (aws_iam_role.retailstore_orders_csi_role) grants permission to 
#   read the `retailstore-db-secret-1` from AWS Secrets Manager.
# - The Secrets Store CSI Driver uses this association to fetch the credentials 
#   securely and mount them into the Orders Pod at runtime.
# - These credentials will later be used by the Orders app to connect to 
#   the **Amazon RDS PostgreSQL Database**.
#
# Without this association, the CSI Driver (or the Pod itself) cannot 
# authenticate with AWS to retrieve secrets.

resource "aws_eks_pod_identity_association" "orders" {
  cluster_name    = data.terraform_remote_state.eks.outputs.eks_cluster_name
  namespace       = "default"
  service_account = "orders"
  role_arn        = aws_iam_role.orders_postgresql_getsecrets.arn
}

################################################################################
# Outputs
################################################################################

# Output: Orders PostgreSQL Pod Identity Association ARN
output "orders_postgresql_sa_pod_identity_association_arn" {
  description = "Pod Identity Association ARN for Orders PostgreSQL ServiceAccount (used for AWS Secrets Manager access)"
  value       = aws_eks_pod_identity_association.orders.association_arn
}
