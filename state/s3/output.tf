output "s3_bucket_domain_name" {
  value       = module.state_backend.s3_bucket_domain_name
  description = "S3 bucket domain name"
}

output "s3_bucket_id" {
  value       = module.state_backend.s3_bucket_id
  description = "S3 bucket ID"
}

output "s3_bucket_arn" {
  value       = module.state_backend.s3_bucket_arn
  description = "S3 bucket ARN"
}

output "dynamodb_table_name" {
  value       = module.state_backend.dynamodb_table_name
  description = "DynamoDB table name"
}

output "dynamodb_table_id" {
  value       = module.state_backend.dynamodb_table_id
  description = "DynamoDB table ID"
}

output "dynamodb_table_arn" {
  value       = module.state_backend.dynamodb_table_arn
  description = "DynamoDB table ARN"
}

output "terraform_backend_config" {
  value       = module.state_backend.terraform_backend_config
  description = "Rendered Terraform backend config file"
}
