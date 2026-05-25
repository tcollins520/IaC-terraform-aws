# AWS Elastic Cache Redis Cluster
resource "aws_elasticache_cluster" "checkout_redis" {
  cluster_id           = "${local.name}-checkout-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_sg.id]
  engine_version       = "7.1"
  parameter_group_name = "default.redis7"

  tags = { Name = "${local.name}-checkout-redis" }
}

# Outputs
output "checkout_redis_endpoint" {
  value = aws_elasticache_cluster.checkout_redis.cache_nodes[0].address
}
