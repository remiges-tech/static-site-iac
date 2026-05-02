output "certificate_dns_validation_records" {
  value = module.site.certificate_dns_validation_records
}

output "website_bucket_name" {
  value = module.site.website_bucket_name
}

output "cloudfront_distribution_id" {
  value = module.site.cloudfront_distribution_id
}

output "cloudfront_distribution_domain_name" {
  value = module.site.cloudfront_distribution_domain_name
}

output "cloudfront_distribution_hosted_zone_id" {
  value = module.site.cloudfront_distribution_hosted_zone_id
}
