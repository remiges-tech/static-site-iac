# Keep ACM validation logic in one file so the same module can run in two modes.
# Route53 mode: Terraform creates validation records and validates the cert in one apply.
# External DNS mode: Terraform only outputs the record details; validation finishes after you add records outside Terraform.
locals {
  # Build ACM's requested validation records once and reuse them for either mode.
  certificate_validation_records = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  # In Route53 mode, read the FQDNs from the records Terraform created.
  # In external DNS mode, the caller supplies the FQDNs after creating the records manually.
  certificate_validation_fqdns = var.manage_dns_in_route53 ? [
    for record in aws_route53_record.cert_validation : record.fqdn
  ] : var.external_dns_validation_record_fqdns

  # Do not try to create CloudFront until we either own DNS in Route53,
  # or the caller has supplied the external validation FQDNs for the second apply.
  cloudfront_enabled = var.manage_dns_in_route53 || length(var.external_dns_validation_record_fqdns) > 0
}

# Create the ACM validation records only when Terraform owns DNS.
resource "aws_route53_record" "cert_validation" {
  for_each = var.manage_dns_in_route53 ? local.certificate_validation_records : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53_zone_id
}

# ACM can only issue the certificate after DNS proves ownership.
# In external DNS mode this is the handoff point between the first and second apply.
resource "aws_acm_certificate_validation" "cert" {
  count = local.cloudfront_enabled ? 1 : 0

  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = local.certificate_validation_fqdns
}
