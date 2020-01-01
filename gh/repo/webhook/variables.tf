variable "github_token" {
  type = string
}

variable "github_organization" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "webhook_url" {
  type = string
}

variable "webhook_content_type" {
  type    = string
  default = "application/json"
}

variable "webhook_insecure_ssl" {
  type    = bool
  default = false
}

variable "webhook_secret" {
  type = string
}

variable "webhook_active" {
  type    = bool
  default = true
}

variable "webhook_events" {
  type = list(string)
  default = [
    "pull-request",
    "pull-request-review",
    "push",
    "issue-comment",
  ]
}
