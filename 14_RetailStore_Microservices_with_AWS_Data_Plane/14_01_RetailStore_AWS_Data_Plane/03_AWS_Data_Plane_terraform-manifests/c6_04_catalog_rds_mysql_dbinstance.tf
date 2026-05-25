# RDS MySQL Database Instance 
resource "aws_db_instance" "catalog_rds" {
  identifier              = "mydb3"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  db_name                 = "catalogdb"
  username                = local.retailstore_secret_json.username
  password                = local.retailstore_secret_json.password
  db_subnet_group_name    = aws_db_subnet_group.rds_private.name
  vpc_security_group_ids  = [aws_security_group.rds_mysql_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = false
  delete_automated_backups = true
  multi_az                = false
  backup_retention_period = 1

  tags = {
    Name = "${local.name}-catalog-rds-mysql"
  }
}


# Outputs
output "catalog_rds_endpoint" {
  description = "RDS endpoint for Catalog microservice"
  value       = aws_db_instance.catalog_rds.address
}

output "catalog_rds_sg_id" {
  description = "RDS security group ID"
  value       = aws_security_group.rds_mysql_sg.id
}
