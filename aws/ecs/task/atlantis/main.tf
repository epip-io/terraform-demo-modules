provider "aws" {
  region = var.aws_region
}

locals {
  atlantis_image = var.atlantis_image == "" ? "runatlantis/atlantis:${var.atlantis_version}" : var.atlantis_image
  atlantis_url   = "https://${element(concat(aws_route53_record.this.*.fqdn, [""]), 0)}"

  container_definition_environment = [
    {
      name  = "ATLANTIS_ALLOW_REPO_CONFIG"
      value = var.atlantis_repo_config
    },
    {
      name  = "ATLANTIS_LOG_LEVEL"
      value = "debug"
    },
    {
      name  = "ATLANTIS_PORT"
      value = var.atlantis_port
    },
    {
      name  = "ATLANTIS_ATLANTIS_URL"
      value = local.atlantis_url
    },
    {
      name  = "ATLANTIS_GH_USER"
      value = var.atlantis_github_user
    },
    {
      name  = "ATLANTIS_REPO_WHITELIST"
      value = join(",", var.atlantis_repo_whitelist)
    },
  ]

  container_definition_secrets = [
    {
      name      = "ATLANTIS_GH_WEBHOOK_SECRET"
      valueFrom = var.atlantis_ssm_parameter_name
    },
    {
      name      = "ATLANTIS_GH_TOKEN"
      valueFrom = var.atlantis_token_ssm_parameter_name
    },
  ]
}

data "aws_caller_identity" "current" {}

module "aws_alb" {
  source = "../../../alb/"

  name = var.name

  vpc_id  = var.vpc_id
  subnets = var.public_subnet_ids

  https_listeners = [
    {
      port            = 443
      certificate_arn = var.certificate_arn
    }
  ]

  target_groups = [
    {
      name                 = replace(var.name, ".", "-")
      backend_protocol     = "HTTP"
      backend_port         = var.atlantis_port
      target_type          = "ip"
      deregistration_delay = 10
    }
  ]
}

module "github_webhook" {
  source = "../../../../gh/repo/webhook"

  github_token        = var.atlantis_github_token
  github_organization = var.atlantis_github_organization
  github_repo         = var.atlantis_github_repo

  webhook_url    = "${local.atlantis_url}/events"
  webhook_secret = random_id.webhook.hex
}

module "container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "v0.21"

  container_name  = var.name
  container_image = var.atlantis_image

  container_cpu                = var.task_cpu
  container_memory             = var.task_memory
  container_memory_reservation = var.task_memory_reservation

  port_mappings = [
    {
      containerPort = var.atlantis_port
      hostPort      = var.atlantis_port
      protocol      = "tcp"
    },
  ]

  log_configuration = {
    logDriver = "awslogs"

    options = {
      "awslogs-region"        = var.aws_region
      "awslogs-group"         = aws_cloudwatch_log_group.this.name
      "awslogs-stream-prefix" = "atlantis"
    }

    secretOptions = []
  }

  environment = local.container_definition_environment

  secrets = local.container_definition_secrets
}

module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.2"

  name        = var.name
  vpc_id      = var.vpc_id
  description = "Security group with open port for Atlantis (${var.atlantis_port}) from ALB, egress ports are all world open"

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = var.atlantis_port
      to_port                  = var.atlantis_port
      protocol                 = "tcp"
      description              = "Atlantis"
      source_security_group_id = module.aws_alb.https_security_group_id
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]
}

resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = format("atlantis.%s", var.name)
  type    = "A"

  alias {
    name                   = module.aws_alb.this_lb_dns_name
    zone_id                = module.aws_alb.this_lb_zone_id
    evaluate_target_health = true
  }
}

resource "random_id" "webhook" {
  byte_length = "64"
}

resource "aws_ssm_parameter" "webhook" {
  name  = var.atlantis_ssm_parameter_name
  type  = "SecureString"
  value = random_id.webhook.hex
}

resource "aws_ssm_parameter" "atlantis_github_user_token" {
  name  = var.atlantis_token_ssm_parameter_name
  type  = "SecureString"
  value = var.atlantis_github_token
}

data "aws_iam_policy_document" "ecs_tasks" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.name}-ecs_task_execution"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks.json
}

// ref: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/specifying-sensitive-data.html
data "aws_iam_policy_document" "ecs_task_access_secrets" {
  statement {
    effect = "Allow"

    resources = [
      "arn:${var.aws_ssm_path}:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${var.atlantis_token_ssm_parameter_name}",
    ]

    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
    ]
  }
}

resource "aws_iam_role_policy" "ecs_task_access_secrets" {
  name = "ECSTaskAccessSecretsPolicy"

  role = aws_iam_role.ecs_task_execution.id

  policy = element(
    compact(data.aws_iam_policy_document.ecs_task_access_secrets.*.json),
    0,
  )
}

resource "aws_ecs_task_definition" "this" {
  family                   = var.name
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_execution.arn
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  container_definitions = module.container_definition.json
}

data "aws_ecs_task_definition" "this" {
  task_definition = var.name

  depends_on = [aws_ecs_task_definition.this]
}

resource "aws_ecs_service" "this" {
  name = var.name

  cluster = var.ecs_cluster_id

  task_definition = "${data.aws_ecs_task_definition.this.family}:${max(
    aws_ecs_task_definition.this.revision,
    data.aws_ecs_task_definition.this.revision,
  )}"

  desired_count                      = 1
  launch_type                        = "EC2"
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 100

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [module.sg.this_security_group_id]
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = var.name

  retention_in_days = var.cloudwatch_log_retention_in_days
}
