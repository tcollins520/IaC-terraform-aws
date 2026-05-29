# Datasource: To get default EKS addon version compatible with EKS cluster version
data "aws_eks_addon_version" "metrics_server_default" {
  addon_name         = "metrics-server"
  kubernetes_version = data.terraform_remote_state.eks.outputs.eks_cluster_version
}

# Datasource: To get latest EKS addon version compatible with EKS cluster version
data "aws_eks_addon_version" "metrics_server_latest" {
  addon_name         = "metrics-server"
  kubernetes_version = data.terraform_remote_state.eks.outputs.eks_cluster_version
  most_recent        = true
}

# EKS Addon: Pod Identity Agent
resource "aws_eks_addon" "metrics_server" {
  cluster_name                = data.terraform_remote_state.eks.outputs.eks_cluster_id
  addon_name                  = "metrics-server"
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  # Use the latest EKS addon version compatible with the cluster's Kubernetes version
  addon_version               = data.aws_eks_addon_version.metrics_server_latest.version
}


# Outputs
output "metrics_server_eksaddon_default_version" {
  value = data.aws_eks_addon_version.metrics_server_default.version
}

output "metrics_server_eksaddon_lastest_version" {
  value = data.aws_eks_addon_version.metrics_server_latest.version
}

output "metrics_server_agent_eksaddon_arn" {
  value = aws_eks_addon.metrics_server.arn
}  

output "metrics_server_agent_eksaddon_id" {
  value = aws_eks_addon.metrics_server.id
}
