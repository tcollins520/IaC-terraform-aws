# AWS Elastic Cache Subnet Group
resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${local.name}-redis-subnets"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
}
