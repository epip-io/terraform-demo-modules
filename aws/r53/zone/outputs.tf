output "domain" {
  description = "Domain of the Zone created"
  value       = var.name
}

output "zone_id" {
  description = "ID of the Zone created"
  value       = aws_route53_zone.this.zone_id
}

output "name_servers" {
  description = "Name servers of the Zone created"
  value       = aws_route53_zone.this.name_servers
}