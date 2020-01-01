variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.mirco"
}

variable "default_security_group_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
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
  default = 0
}

variable "wait_for_capacity_timeout" {
  type    = number
  default = 0
}