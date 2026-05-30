# IAM Role for Pod Identity (for AWS Secrets Store CSI Driver)
resource "aws_iam_role" "orders_postgresql_getsecrets" {
  name               = "${local.name}-orders-postgresql-getsecrets-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    Name        = "${local.name}-orders-postgresql-getsecrets-role"
    Environment = var.environment_name
    Component   = "AWS Secrets Store CSI Driver ASCP"
  }
}

# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "orders_postgresql_db_secret_attach" {
  policy_arn = aws_iam_policy.retailstore_db_secret_policy.arn
  role       = aws_iam_role.orders_postgresql_getsecrets.name
}

# Outputs
output "orders_postgresql_sa_getsecrets_role_arn" {
  description = "IAM Role ARN for Orders PostgreSQL Get Secrets from AWS Secrets Manager"
  value       = aws_iam_role.orders_postgresql_getsecrets.arn
}
