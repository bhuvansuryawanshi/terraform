output "domain_dns" {
  description = "Amplify domain DNS records for Route53 alias"
  value       = [for s in aws_amplify_domain_association.domain_association.sub_domain : s.dns_record]
}
