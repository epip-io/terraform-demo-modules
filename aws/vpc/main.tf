
provider "aws" {
  region = var.aws_region
}

locals {
  num_azs = length(var.azs)

  azs = [
    for az in var.azs : format("%s%s", var.aws_region, az)
  ]

  bits = local.num_azs > 3 ? 4 : 2

  public_subnets = [
    for i in range(local.num_azs) : "${cidrsubnet(
      cidrsubnet(var.cidr, local.bits, local.num_azs),
      local.bits, i
    )}"
  ]
  private_subnets = [
    for i in range(local.num_azs) : "${cidrsubnet(var.cidr, local.bits, i)}"
  ]
}

module "aws_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2.21"

  name = var.name

  cidr             = var.cidr
  instance_tenancy = var.tenancy

  azs             = local.azs
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets

  map_public_ip_on_launch = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = false

  enable_s3_endpoint                   = true
  enable_dynamodb_endpoint             = true
  enable_secretsmanager_endpoint       = true
  enable_ssm_endpoint                  = true
  enable_ssmmessages_endpoint          = true
  enable_ec2_endpoint                  = true
  enable_ec2messages_endpoint          = true
  enable_ecr_api_endpoint              = true
  enable_ecr_dkr_endpoint              = true
  enable_ecs_endpoint                  = true
  enable_ecs_agent_endpoint            = true
  enable_ecs_telemetry_endpoint        = true
  enable_monitoring_endpoint           = true
  enable_logs_endpoint                 = true
  enable_events_endpoint               = true
  enable_elasticloadbalancing_endpoint = true
  enable_sts_endpoint                  = true

  public_subnet_suffix = "utility"
}
