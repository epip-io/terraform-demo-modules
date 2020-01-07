output "id" {
  value       = module.acm_request_certificate.id
  description = "The ID of the certificate"
}

output "arn" {
  value       = module.acm_request_certificate.arn
  description = "The ARN of the certificate"
}

output "domain_validation_options" {
  value       = module.acm_request_certificate.domain_validation_options
  description = "CNAME records that are added to the DNS zone to complete certificate validation"
}