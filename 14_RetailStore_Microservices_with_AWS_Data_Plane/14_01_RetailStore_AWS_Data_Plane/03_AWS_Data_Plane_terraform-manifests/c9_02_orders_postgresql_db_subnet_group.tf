# RDS PostgreSQL Database Subnet Group for Orders Microservice
resource "aws_db_subnet_group" "rds_postgresql_subnet_group" {
  name       = "${local.name}-rds-postgresql-subnet-group"
  description = "Subnet group for Orders RDS PostgreSQL"
  subnet_ids  = data.terraform_remote_state.vpc.outputs.private_subnet_ids

  tags = {
    Name = "${local.name}-rds-postgresql-subnet-group"
  }
}
