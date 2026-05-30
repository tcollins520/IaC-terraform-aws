# EKS Pod Identity Association
resource "aws_eks_pod_identity_association" "cart_pod_identity" {
  cluster_name    = data.terraform_remote_state.eks.outputs.eks_cluster_name
  namespace       = "default"
  service_account = "carts"
  role_arn        = aws_iam_role.cart_dynamodb_role.arn
}

# Output: Cart DynamoDB Pod Identity Association ARN
output "cart_dynamodb_pod_identity_association_arn" {
  description = "Pod Identity Association ARN for Cart DynamoDB ServiceAccount"
  value       = aws_eks_pod_identity_association.cart_pod_identity.association_arn
}
