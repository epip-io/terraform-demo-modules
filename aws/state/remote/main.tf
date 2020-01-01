provider "aws" {
  region = var.aws_region
}

module "state_store" {
  source = "../"

  region = var.aws_region
  path   = var.path
  bucket = var.bucket
}