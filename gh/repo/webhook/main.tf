provider "github" {
  token        = var.github_token
  organization = var.github_organization
}

resource "github_repository_webhook" "this" {
  repository = var.github_repo

  configuration {
    url          = var.webhook_url
    content_type = var.webhook_content_type
    insecure_ssl = var.webhook_insecure_ssl
    secret       = var.webhook_secret
  }

  active = var.webhook_active

  events = var.webhook_events
}
