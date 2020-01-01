terraform {
  required_version = "~> 0.12.18"

  required_providers {
    aws = "~> 2.43"
  }

  # This gets filled in by Terragrunt
  backend "s3" {}
}