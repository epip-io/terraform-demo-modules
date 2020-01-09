provider "aws" {
  region = var.region
}

locals {
  subject_alternative_names = distinct(
    concat(
      var.subject_alternative_names,
      formatlist("*.%s", [var.domain_name])
    )
  )
}

module "acm_request_certificate" {
  source                    = "git::https://github.com/cloudposse/terraform-aws-acm-request-certificate.git?ref=tags/0.4.0"
  domain_name               = var.domain_name
  ttl                       = 300
  subject_alternative_names = local.subject_alternative_names
  tags                      = var.tags
}