variable "region" {
  default = "us-east-1"
}
variable "path" {
  default     = "/"
  description = "Path for IAM resources.  Must start and end with `/`"
}
variable "bucket" {
  description = "S3 bucket name."
}
