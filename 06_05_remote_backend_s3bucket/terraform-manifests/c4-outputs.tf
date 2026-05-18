
output "tfstate_bucket_arn" {
  description = "ARN of the Terraform remote state S3 bucket"
  value       = aws_s3_bucket.tfstate_bucket.arn
}

output "tfstate_bucket_id" {
  description = "Bucket ID (same as name) for Terraform state"
  value       = aws_s3_bucket.tfstate_bucket.id
}

