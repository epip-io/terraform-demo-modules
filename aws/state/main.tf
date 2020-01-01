data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.this.arn
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]
  }

  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]
    resources = [
      aws_dynamodb_table.this.arn
    ]
  }

}

resource "aws_iam_policy" "this" {
  name   = "TerraformStateFullAccess"
  path   = var.path
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket
  acl    = "private"
  region = var.region

  force_destroy = true

  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = "ONEZONE_IA"
    }
  }

  tags = {
    Name = "S3 backend bucket"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_dynamodb_table" "this" {
  name         = "${var.bucket}-locks"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${var.bucket} S3 Backend Locks"
  }
}
