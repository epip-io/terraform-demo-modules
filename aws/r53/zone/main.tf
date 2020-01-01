provider "aws" {
  region = var.aws_region
}

resource "aws_route53_zone" "this" {
  name = var.name
}