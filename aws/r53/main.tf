provider "aws" {
  region = var.region
}

module "r53" {
  source           = "git::https://github.com/cloudposse/terraform-aws-route53-cluster-zone.git?ref=tags/0.4.0"
  enabled          = true
  namespace        = var.namespace
  stage            = var.stage
  name             = var.name
  parent_zone_name = var.parent_zone_name
  zone_name        = var.zone_name
}
