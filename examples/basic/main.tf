module "site" {
  source = "../../modules/static-site"

  bucket_name                          = var.bucket_name
  environment                          = var.environment
  domain_name                          = var.domain_name
  subject_alternative_names            = var.subject_alternative_names
  manage_dns_in_route53                = var.manage_dns_in_route53
  route53_zone_id                      = var.route53_zone_id
  external_dns_validation_record_fqdns = var.external_dns_validation_record_fqdns
  create_static_site_plugin_policy     = var.create_static_site_plugin_policy

  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }
}
