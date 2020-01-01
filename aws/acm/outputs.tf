output "this_acm_certificate_arn" {
  value = module.aws_acm.this_acm_certificate_arn
}

output "this_acm_certificate_domain_validation_options" {
  description = "A list of attributes to feed into other resources to complete certificate validation. Can have more than one element, e.g. if SANs are defined. Only set if DNS-validation was used."
  value       = module.aws_acm.this_acm_certificate_domain_validation_options
}

output "this_acm_certificate_validation_emails" {
  description = "A list of addresses that received a validation E-Mail. Only set if EMAIL-validation was used."
  value       = module.aws_acm.this_acm_certificate_validation_emails
}

output "validation_route53_record_fqdns" {
  description = "List of FQDNs built using the zone domain and name."
  value       = module.aws_acm.validation_route53_record_fqdns
}

output "distinct_domain_names" {
  description = "List of distinct domains names used for the validation."
  value       = module.aws_acm.distinct_domain_names
}

output "validation_domains" {
  description = "List of distinct domain validation options. This is useful if subject alternative names contain wildcards."
  value       = module.aws_acm.validation_domains
}