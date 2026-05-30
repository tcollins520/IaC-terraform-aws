# DB Subnet Group (using private subnets from VPC project)
resource "aws_db_subnet_group" "rds_private" {
  name       = "${local.name}-rds-private-subnets"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  tags = {
    Name = "${local.name}-rds-private-subnets"
  }
}