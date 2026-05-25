# ORDERS - AWS SQS Queue for Asynchronous Order Messaging
resource "aws_sqs_queue" "orders_sqs_queue" {
  name                        = "${local.name}-orders-queue"
  message_retention_seconds   = 86400     # 1 day
  visibility_timeout_seconds  = 30
  delay_seconds               = 0
  receive_wait_time_seconds   = 10

  tags = {
    Name        = "${local.name}-orders-queue"
    Component   = "Orders"
    Environment = var.environment_name
  }
}

# Outputs
output "orders_sqs_queue_url" {
  description = "SQS Queue URL for Orders microservice"
  value       = aws_sqs_queue.orders_sqs_queue.url
}

output "orders_sqs_queue_arn" {
  description = "SQS Queue ARN for Orders microservice"
  value       = aws_sqs_queue.orders_sqs_queue.arn
}
