terraform {
  required_version = "~> 0.12.9"

  required_providers {
    aws = "~> 2.43"
    tls = "~> 2.1"
  }

  # This gets filled in by Terragrunt
  backend "s3" {}
}
