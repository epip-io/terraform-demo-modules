terraform {
  required_version = "~> 0.12.9"

  required_providers {
    aws      = "~> 2.43"
    null     = "~> 2.1"
    random   = "~> 2.2"
    template = "~> 2.1"
  }

  # This gets filled by Terragrunt
  backend "s3" {}
}