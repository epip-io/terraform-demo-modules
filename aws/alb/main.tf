locals {
  name = replace(var.name, ".", "-")
}

module "aws_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = local.name

  vpc_id          = var.vpc_id
  subnets         = var.subnets
  security_groups = flatten([module.alb_https_sg.this_security_group_id, module.alb_http_sg.this_security_group_id, var.security_group_ids])

  https_listeners    = var.https_listeners
  http_tcp_listeners = var.http_listeners
  target_groups      = var.target_groups

  enable_cross_zone_load_balancing = true
}

###################
# Security groups
###################
module "alb_https_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/https-443"
  version = "~> 3.2"

  name        = "${local.name}-alb-https"
  vpc_id      = var.vpc_id
  description = "Security group with HTTPS ports open for specific IPv4 CIDR block (or everybody), egress ports are all world open"

  ingress_cidr_blocks = var.alb_ingress_cidr_blocks
}

module "alb_http_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/http-80"
  version = "~> 3.2"

  name        = "${local.name}-alb-http"
  vpc_id      = var.vpc_id
  description = "Security group with HTTP ports open for specific IPv4 CIDR block (or everybody), egress ports are all world open"

  ingress_cidr_blocks = var.alb_ingress_cidr_blocks
}
