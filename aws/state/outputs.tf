output "policy_id" {
  value = aws_iam_policy.this.id
}

output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "table_id" {
  value = aws_dynamodb_table.this.id
}

output "table_arn" {
  value = aws_dynamodb_table.this.arn
}