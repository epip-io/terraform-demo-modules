provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "secrets" {
  for_each = {
    for s in var.container_secrets :
    s.name => s.value
    if s.value == ""
  }

  name = "/${lower(replace(each.key, "_", "/"))}"
}

locals {
  secrets = [
    for s in var.container_secrets : {
      name      = s.name
      valueFrom = "/${lower(replace(s.name, "_", "/"))}"
    }
  ]
}

resource "aws_ssm_parameter" "secrets" {
  for_each = {
    for s in var.container_secrets :
    s.name => s.value
    if s.value != ""
  }

  name  = "/${lower(replace(each.key, "_", "/"))}"
  value = each.value
  type  = "SecureString"
}

module "app" {
  source = "git::https://github.com/cloudposse/terraform-aws-ecs-web-app.git?ref=tags/0.24.0"

  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  attributes = compact(concat(var.attributes, ["app"]))

  region      = var.region
  launch_type = "EC2"
  vpc_id      = var.vpc_id

  desired_count = 1

  container_image  = var.container_image
  container_cpu    = var.container_cpu
  container_memory = var.container_memory
  container_port   = var.container_port
  port_mappings = [{
    containerPort = var.container_port
    hostPort      = var.container_port
    protocol      = "tcp"
  }]

  environment = var.container_environment
  secrets     = local.secrets

  aws_logs_region        = var.region
  ecs_cluster_arn        = var.ecs_arn
  ecs_cluster_name       = var.ecs_name
  ecs_security_group_ids = var.ecs_security_group_ids
  ecs_private_subnet_ids = var.subnet_ids
  ecs_alarms_enabled     = false

  alb_security_group              = var.alb_security_group
  alb_arn_suffix                  = var.alb_arn_suffix
  alb_ingress_healthcheck_path    = "/"
  alb_target_group_alarms_enabled = false

  # Without authentication, both HTTP and HTTPS endpoints are supported
  alb_ingress_unauthenticated_listener_arns       = var.alb_ingress_unauthenticated_listener_arns
  alb_ingress_unauthenticated_listener_arns_count = length(var.alb_ingress_unauthenticated_listener_arns)

  # All paths are unauthenticated
  alb_ingress_unauthenticated_hosts             = var.alb_ingress_unauthenticated_hosts
  alb_ingress_listener_unauthenticated_priority = var.alb_ingress_listener_unauthenticated_priority

  alb_target_group_alarms_alarm_actions             = [""]
  alb_target_group_alarms_ok_actions                = [""]
  alb_target_group_alarms_insufficient_data_actions = [""]

  repo_owner = var.repo_owner
  repo_name  = var.repo_name

  github_webhooks_token = var.github_token

  codepipeline_enabled = false
}

data "aws_iam_policy_document" "ecs_task_access_secrets" {
  statement {
    effect = "Allow"

    resources = [
      for s in var.container_secrets :
      "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/${lower(replace(s.name, "_", "/"))}"
    ]

    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
    ]
  }
}

resource "aws_iam_role_policy" "ecs_task_access_secrets" {
  count = length(var.container_secrets) > 0 ? 1 : 0

  name = "ECSTaskAccessSecretsPolicy"

  role = module.app.ecs_task_exec_role_name

  policy = element(
    compact(
      data.aws_iam_policy_document.ecs_task_access_secrets.*.json,
    ),
    0,
  )
}

resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = "${var.name}.${var.zone_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
