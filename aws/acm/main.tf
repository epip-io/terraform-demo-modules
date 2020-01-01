provider "aws" {
  region = var.aws_region
}

locals {
  subject_alternative_names = [
    var.name,
    format("*.%s", var.name)
  ]
}

module "aws_acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 2.5"

  domain_name = var.name

  zone_id = var.zone_id

  subject_alternative_names = local.subject_alternative_names

  tags = {
    Name = var.name
  }
}