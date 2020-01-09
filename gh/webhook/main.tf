provider "aws" {
  region = var.region
}
###################
# Secret for webhook
###################
resource "random_id" "webhook" {
  byte_length = "64"
}

resource "aws_ssm_parameter" "webhook" {
  name  = "/${lower(replace(var.name, "_", "/"))}"
  type  = "SecureString"
  value = random_id.webhook.hex
}

module "webhooks" {
  source = "git::https://github.com/cloudposse/terraform-github-repository-webhooks.git?ref=tags/0.5.0"

  active              = var.active
  github_token        = var.github_token
  github_organization = var.github_organization
  github_repositories = var.github_repositories

  webhook_secret = random_id.webhook.hex
  webhook_url    = var.webhook_url
  events         = var.events
}