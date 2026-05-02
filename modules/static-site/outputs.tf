output "acm_certificate_arn" {
  description = "ARN of the ACM certificate requested for the site"
  value       = aws_acm_certificate.cert.arn
}

output "certificate_dns_validation_records" {
  description = "DNS records required to validate the ACM certificate"
  value       = local.certificate_validation_records
}

output "website_bucket_name" {
  description = "Name of the S3 bucket that stores the website content"
  value       = aws_s3_bucket.website.bucket
}

output "website_bucket_arn" {
  description = "ARN of the S3 bucket that stores the website content"
  value       = aws_s3_bucket.website.arn
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID. Null until the distribution is created"
  value       = local.cloudfront_enabled ? aws_cloudfront_distribution.website[0].id : null
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN. Null until the distribution is created"
  value       = local.cloudfront_enabled ? aws_cloudfront_distribution.website[0].arn : null
}

output "cloudfront_distribution_domain_name" {
  description = "CloudFront domain name to use when managing DNS outside Route53"
  value       = local.cloudfront_enabled ? aws_cloudfront_distribution.website[0].domain_name : null
}

output "cloudfront_distribution_hosted_zone_id" {
  description = "CloudFront hosted zone ID for alias records"
  value       = local.cloudfront_enabled ? aws_cloudfront_distribution.website[0].hosted_zone_id : null
}

output "static_site_plugin_policy_arn" {
  description = "ARN of the static site plugin IAM policy, if created"
  value       = length(aws_iam_policy.static_site_plugin) > 0 ? aws_iam_policy.static_site_plugin[0].arn : null
}
