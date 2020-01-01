variable "aws_region" {
  default = "us-east-1"
}
variable "name" {
  description = "The name of the hosted zone"
}

variable "vpc_id" {
  description = "The VPC to associate with a private hosted zone. Specifying vpc_id will create a private hosted zone."
  default     = ""
}
