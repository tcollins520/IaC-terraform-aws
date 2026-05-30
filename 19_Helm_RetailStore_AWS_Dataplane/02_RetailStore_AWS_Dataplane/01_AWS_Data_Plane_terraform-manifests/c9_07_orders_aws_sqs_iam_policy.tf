# IAM Policy to Allow Orders Microservice Access to SQS
resource "aws_iam_policy" "orders_sqs_policy" {
  name        = "${local.name}-orders-sqs-policy"
  description = "Allow Orders microservice to interact with Amazon SQS"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "OrdersSQSAccess"
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ListQueues",
          "sqs:PurgeQueue"
        ]
        Resource = aws_sqs_queue.orders_sqs_queue.arn
      }
    ]
  })
}

# Attach New SQS Policy to Existing Orders IAM Role
# Note: Reuses the same IAMrole that already has Secrets Manager permissions.
resource "aws_iam_role_policy_attachment" "orders_sqs_policy_attach" {
  depends_on = [aws_iam_policy.orders_sqs_policy]
  policy_arn = aws_iam_policy.orders_sqs_policy.arn
  role       = aws_iam_role.orders_postgresql_getsecrets.name
}

# Outputs
output "orders_sqs_policy_arn" {
  description = "ARN of the IAM policy granting SQS access for Orders microservice"
  value       = aws_iam_policy.orders_sqs_policy.arn
}
