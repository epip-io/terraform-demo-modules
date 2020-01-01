output "this_lb_id" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.aws_alb.this_lb_id
}

output "this_lb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.aws_alb.this_lb_arn
}

output "this_lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.aws_alb.this_lb_dns_name
}

output "this_lb_arn_suffix" {
  description = "ARN suffix of our load balancer - can be used with CloudWatch."
  value       = module.aws_alb.this_lb_arn_suffix
}

output "this_lb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = module.aws_alb.this_lb_zone_id
}

output "http_tcp_listener_arns" {
  description = "The ARN of the TCP and HTTP load balancer listeners created."
  value       = module.aws_alb.http_tcp_listener_arns
}

output "http_tcp_listener_ids" {
  description = "The IDs of the TCP and HTTP load balancer listeners created."
  value       = module.aws_alb.http_tcp_listener_ids
}

output "https_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created."
  value       = module.aws_alb.https_listener_arns
}

output "https_listener_ids" {
  description = "The IDs of the load balancer listeners created."
  value       = module.aws_alb.https_listener_ids
}

output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value       = module.aws_alb.target_group_arns
}

output "target_group_arn_suffixes" {
  description = "ARN suffixes of our target groups - can be used with CloudWatch."
  value       = module.aws_alb.target_group_arn_suffixes
}

output "target_group_names" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value       = module.aws_alb.target_group_names
}

output "http_security_group_id" {
  description = "The ID of the security group"
  value       = module.alb_http_sg.this_security_group_id
}

output "http_security_group_vpc_id" {
  description = "The VPC ID"
  value       = module.alb_http_sg.this_security_group_vpc_id
}

output "http_security_group_owner_id" {
  description = "The owner ID"
  value       = module.alb_http_sg.this_security_group_owner_id
}

output "http_security_group_name" {
  description = "The name of the security group"
  value       = module.alb_http_sg.this_security_group_name
}

output "http_security_group_description" {
  description = "The description of the security group"
  value       = module.alb_http_sg.this_security_group_description
}

output "https_security_group_id" {
  description = "The ID of the security group"
  value       = module.alb_https_sg.this_security_group_id
}

output "https_security_group_vpc_id" {
  description = "The VPC ID"
  value       = module.alb_https_sg.this_security_group_vpc_id
}

output "https_security_group_owner_id" {
  description = "The owner ID"
  value       = module.alb_https_sg.this_security_group_owner_id
}

output "https_security_group_name" {
  description = "The name of the security group"
  value       = module.alb_https_sg.this_security_group_name
}

output "https_security_group_description" {
  description = "The description of the security group"
  value       = module.alb_https_sg.this_security_group_description
}
