variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "alb_ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules of the ALB."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "https_listeners" {
  type = list(object({
    port            = number
    certificate_arn = string
  }))
}

variable "http_listeners" {
  type = list(object({
    port     = number
    protocol = string
  }))

  default = [
    {
      port     = 80
      protocol = "HTTP"
    }
  ]
}

variable "target_groups" {
  type = list(object({
    name                 = string
    backend_protocol     = string
    backend_port         = number
    target_type          = string
    deregistration_delay = number
  }))
}
