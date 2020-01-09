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
  description = "AWS region"
}

variable "github_token" {
  type        = string
  default     = ""
  description = "GitHub token used for API access. If not provided, can be sourced from the `GITHUB_TOKEN` environment variable"
}

variable "github_organization" {
  type        = string
  description = "GitHub organization to use when creating webhooks"
}

variable "github_repositories" {
  type        = list(string)
  description = "List of repository names which should be associated with the webhook"
  default     = []
}

variable "webhook_url" {
  type        = string
  description = "Webhook URL"
}

variable "events" {
  # Full list of events available here: https://developer.github.com/v3/activity/events/types/
  type        = list(string)
  description = "A list of events which should trigger the webhook."
}

variable "active" {
  type        = bool
  description = "Activate the webhook"
  default     = false
}