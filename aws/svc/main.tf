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

module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags
}
resource "aws_cloudwatch_log_group" "app" {
  name = module.default_label.id
  tags = module.default_label.tags
}

module "alb_ingress" {
  source                       = "git::https://github.com/cloudposse/terraform-aws-alb-ingress.git?ref=tags/0.9.0"
  name                         = var.name
  namespace                    = var.namespace
  stage                        = var.stage
  attributes                   = var.attributes
  vpc_id                       = var.vpc_id
  port                         = var.container_port
  health_check_enabled         = var.health_check_enabled
  health_check_port            = var.health_check_port
  health_check_path            = var.health_check_path
  health_check_matcher         = var.health_check_matcher
  default_target_group_enabled = true
  target_type                  = var.target_type

  unauthenticated_hosts = var.unauthenticated_hosts

  unauthenticated_priority = var.unauthenticated_priority

  unauthenticated_listener_arns       = var.unauthenticated_listener_arns
  unauthenticated_listener_arns_count = length(var.unauthenticated_listener_arns)
}

module "container_definition" {
  source                       = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition.git?ref=tags/0.21.0"
  container_name               = module.default_label.id
  container_image              = var.container_image
  container_memory             = var.container_memory
  container_memory_reservation = var.container_memory_reservation
  container_cpu                = var.container_cpu
  healthcheck                  = var.healthcheck
  environment                  = var.container_environment
  port_mappings                = var.port_mappings
  secrets                      = local.secrets
  command                      = var.command
  entrypoint                   = var.entrypoint

  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region"        = var.region
      "awslogs-group"         = aws_cloudwatch_log_group.app.name
      "awslogs-stream-prefix" = var.name
    }
    secretOptions = null
  }
}

module "ecs_alb_service_task" {
  source                            = "git::https://github.com/cloudposse/terraform-aws-ecs-alb-service-task.git?ref=tags/0.17.0"
  name                              = var.name
  namespace                         = var.namespace
  stage                             = var.stage
  attributes                        = var.attributes
  alb_security_group                = var.alb_security_group
  container_definition_json         = module.container_definition.json
  desired_count                     = var.desired_count
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  task_cpu                          = var.container_cpu
  task_memory                       = var.container_memory
  ecs_cluster_arn                   = var.ecs_cluster_arn
  launch_type                       = var.launch_type
  vpc_id                            = var.vpc_id
  security_group_ids                = var.security_group_ids
  subnet_ids                        = var.subnet_ids
  container_port                    = var.container_port
  tags                              = var.tags
  ignore_changes_task_definition    = var.ignore_changes_task_definition
  network_mode                      = var.network_mode

  ecs_load_balancers = [
    {
      container_name   = module.default_label.id
      container_port   = var.container_port
      elb_name         = null
      target_group_arn = module.alb_ingress.target_group_arn
  }]
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

resource "aws_iam_policy" "ecs_task_access_secrets" {
  count = length(var.container_secrets) > 0 ? 1 : 0

  name = "${module.default_label.id}-secrets"

  policy = element(
    compact(
      data.aws_iam_policy_document.ecs_task_access_secrets.*.json,
    ),
    0,
  )
}

resource "aws_iam_role_policy_attachment" "ecs_task_access_secrets" {
  count = length(var.container_secrets) > 0 ? 1 : 0

  role       = module.ecs_alb_service_task.task_exec_role_name
  policy_arn = aws_iam_policy.ecs_task_access_secrets[0].arn
}

resource "aws_iam_role_policy_attachment" "task_role_policies" {
  for_each = toset(var.task_role_policy_arns)

  role       = module.ecs_alb_service_task.task_role_name
  policy_arn = each.value

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
