provider "aws" {
  region = var.region
}

module "alb" {
  source                                  = "git::https://github.com/cloudposse/terraform-aws-alb.git?ref=tags/0.7.0"
  namespace                               = var.namespace
  stage                                   = var.stage
  name                                    = var.name
  attributes                              = var.attributes
  delimiter                               = var.delimiter
  vpc_id                                  = var.vpc_id
  security_group_ids                      = var.security_group_ids
  subnet_ids                              = var.subnet_ids
  internal                                = false
  http_enabled                            = true
  https_enabled                           = true
  certificate_arn                         = var.certificate_arn
  alb_access_logs_s3_bucket_force_destroy = true
  access_logs_enabled                     = false
  cross_zone_load_balancing_enabled       = true
  http2_enabled                           = true
  deletion_protection_enabled             = false
  tags                                    = var.tags
  target_group_name                       = var.target_group_name
}
