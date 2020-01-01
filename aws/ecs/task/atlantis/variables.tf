variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "zone_id" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "atlantis_image" {
  type    = string
  default = ""
}

variable "atlantis_version" {
  type    = string
  default = ""
}

variable "atlantis_port" {
  type    = number
  default = 4141
}

variable "atlantis_repo_whitelist" {
  type = list(string)
}

variable "atlantis_repo_config" {
  type    = string
  default = "true"
}

variable "atlantis_github_user" {
  type = string
}

variable "atlantis_github_organization" {
  type = string
}

variable "atlantis_github_repo" {
  type = string
}

variable "atlantis_github_token" {
  type = string
}

variable "atlantis_token_ssm_parameter_name" {
  description = "Name of SSM parameter to keep atlantis_github_token"
  type        = string
  default     = "/atlantis/github/token"
}

variable "atlantis_ssm_parameter_name" {
  description = "Name of SSM parameter to keep the atlantis shared secret"
  type        = string
  default     = "/atlantis/webhook"
}

variable "task_cpu" {
  type    = number
  default = 256
}

variable "task_memory" {
  type    = number
  default = 512
}

variable "task_memory_reservation" {
  type    = number
  default = 128
}

variable "aws_ssm_path" {
  description = "AWS ARN prefix for SSM (public AWS region or Govcloud). Valid options: aws, aws-us-gov."
  type        = string
  default     = "aws"
}

variable "ecs_cluster_id" {
  type = string
}

variable "cloudwatch_log_retention_in_days" {
  type    = number
  default = 1
}
