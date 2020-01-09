output "parent_zone_id" {
  value       = module.r53.parent_zone_id
  description = "ID of the hosted zone to contain this record"
}

output "parent_zone_name" {
  value       = module.r53.parent_zone_name
  description = "Name of the hosted zone to contain this record"
}

output "zone_id" {
  value       = module.r53.zone_id
  description = "Route53 DNS Zone ID"
}

output "zone_name" {
  value       = module.r53.zone_name
  description = "Route53 DNS Zone name"
}

output "fqdn" {
  value       = module.r53.fqdn
  description = "Fully-qualified domain name"
}