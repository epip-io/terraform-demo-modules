provider "aws" {
  region = var.region
}

locals {
  userdata = <<-USERDATA
    #!/bin/bash
    mkdir -p /etc/ecs
    echo 'ECS_CLUSTER=${aws_ecs_cluster.this.name}' >> /etc/ecs/ecs.config
  USERDATA
}

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "ecs_role_label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  name      = var.name
  namespace = var.namespace
  stage     = var.stage
  tags      = var.tags
  attributes = [
    "role"
  ]
  delimiter = var.delimiter
}

resource "aws_iam_role" "this" {
  name = module.ecs_role_label.id

  assume_role_policy = <<-EOT
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
    EOT
}

locals {
  managed_roles = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
  ]
}

resource "aws_iam_role_policy_attachment" "this" {
  role = aws_iam_role.this.name

  count      = length(local.managed_roles)
  policy_arn = element(local.managed_roles, count.index)
}

resource "aws_iam_instance_profile" "this" {
  name = module.ecs_cluster_label.id
  role = aws_iam_role.this.name
}

module "ecs_sg_label" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  name      = var.name
  namespace = var.namespace
  stage     = var.stage
  tags      = var.tags
  attributes = [
    "role"
  ]
  delimiter = var.delimiter
}

resource "aws_security_group" "ecs" {
  name        = module.ecs_sg_label.id
  description = "Container Instance Allowed Ports"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 1
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "asg" {
  source = "git::https://github.com/cloudposse/terraform-aws-ec2-autoscale-group.git?ref=tags/0.2.1"

  namespace = var.namespace
  stage     = var.stage
  name      = var.name

  iam_instance_profile_name = aws_iam_instance_profile.this.name
  image_id                  = join("", data.aws_ami.ecs_ami.*.image_id)
  instance_type             = var.instance_type
  security_group_ids = compact(
    concat([aws_security_group.ecs.id], var.security_group_ids)
  )
  subnet_ids                  = var.subnet_ids
  health_check_type           = "EC2"
  min_size                    = var.min_size
  max_size                    = var.max_size
  wait_for_capacity_timeout   = "5m"
  associate_public_ip_address = false
  user_data_base64            = "${base64encode(local.userdata)}"

  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = "true"
  cpu_utilization_high_threshold_percent = "70"
  cpu_utilization_low_threshold_percent  = "20"

  tags = {
    ecs-cluster = aws_ecs_cluster.this.name
  }
}

module "ecs_cluster_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
  attributes = var.attributes
  delimiter  = var.delimiter
}

resource "aws_ecs_cluster" "this" {
  name = module.ecs_cluster_label.id
}
