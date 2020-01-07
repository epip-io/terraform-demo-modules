variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "stage" {
  type        = string
  default     = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  type        = string
  default     = "terraform"
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  default     = ["state"]
  description = "Additional attributes (e.g. `state`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}

variable "additional_tag_map" {
  type        = map(string)
  default     = {}
  description = "Additional tags for appending to each tag map"
}

variable "region" {
  type        = string
  description = "AWS Region the S3 bucket should reside in"
}

variable "vpc_id" {
  type = string
}

variable "container_image" {
  type        = string
  description = "Container repository and tag"
}

variable "container_cpu" {
  type        = number
  description = "Container max CPU"
}

variable "container_memory" {
  type        = number
  description = "Container max Memory"
}

variable "container_port" {
  type        = number
  description = "Container port to expose"
}

variable "container_secrets" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Secrets for the tasks, values stored in SSM"
}

variable "container_environment" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Secrets for the tasks, values stored in SSM"
}

variable "ecs_name" {
  type        = string
  description = "AWS ECS cluster name to associate with"
}

variable "ecs_arn" {
  type        = string
  description = "AWS ECS cluster arn to associate with"
}

variable "ecs_security_group_ids" {
  type        = list(string)
  description = "Security Group of the LB"
}

variable "subnet_ids" {
  type        = list(string)
  description = "AWS subnet IDs to associate with"
}

variable "alb_security_group" {
  type        = string
  description = "Security Group of the LB"
}

variable "alb_arn_suffix" {
  type        = string
  description = "ARN suffix of the LB"
}

variable "alb_ingress_healthcheck_path" {
  type        = string
  description = "Healthcheck endpoint for LB to use"
  default     = "/"
}

variable "alb_ingress_unauthenticated_listener_arns" {
  type = list(string)
}

variable "alb_ingress_unauthenticated_hosts" {
  type    = list(string)
}

variable "alb_ingress_listener_unauthenticated_priority" {
  type    = number
  default = 100
}

variable "repo_owner" {
  type = string
}

variable "repo_name" {
  type = string
}

variable "github_token" {
  type = string
}

variable "alb_zone_id" {
  type = string
}

variable "alb_dns_name" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "zone_name" {
  type = string
}
