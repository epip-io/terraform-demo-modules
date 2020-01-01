provider "aws" {
  region = var.aws_region
}

locals {

}

module "aws_ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 2.0"

  name = var.name
}

module "aws_ecs_profile" {
  source  = "terraform-aws-modules/ecs/aws//modules/ecs-instance-profile"
  version = "~> 2.0"

  name = var.name
}

#For now we only use the AWS ECS optimized ami <https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html>
data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

module "aws_autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = var.name

  # Launch configuration
  lc_name = var.name

  image_id             = data.aws_ami.amazon_linux_ecs.id
  instance_type        = var.instance_type
  security_groups      = [var.default_security_group_id]
  iam_instance_profile = module.aws_ecs_profile.this_iam_instance_profile_id
  user_data            = data.template_file.user_data.rendered

  # Auto scaling group
  asg_name                  = var.name
  vpc_zone_identifier       = var.private_subnets
  health_check_type         = "EC2"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout

  tags = [
    {
      key                 = "clusterName"
      value               = var.name
      propagate_at_launch = true
    },
  ]

}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user-data.sh")

  vars = {
    cluster_name = var.name
  }
}
