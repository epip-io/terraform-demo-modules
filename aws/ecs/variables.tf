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
  type        = string
  description = "VPC ID to associate with ECS"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to associate with ECS"
}

variable "instance_type" {
  type        = string
  description = "Instance type to use for ECS cluster"
  default     = "t2.micro"
}

variable "root_block_device_type" {
  type        = string
  description = "root block device type"
  default     = "gp2"
}

variable "root_block_device_size" {
  type        = number
  description = "root block device size"
  default     = 10
}

variable "health_check_grace_period" {
  type    = number
  default = 600
}

variable "min_size" {
  type    = number
  default = 0
}

variable "max_size" {
  type    = number
  default = 1
}

variable "desired_capacity" {
  type    = number
  default = 1
}

variable "security_group_ids" {
  type = list(string)
}
