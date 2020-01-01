variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "name" {
  type = string
}

variable "tenancy" {
  type    = string
  default = "dedicated"
}

variable "azs" {
  type = list(string)
  default = [
    "a",
    "b",
    "c",
  ]
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/17"
}
