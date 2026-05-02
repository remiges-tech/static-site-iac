# Website DNS record when Terraform manages DNS in Route53.
# External DNS providers can ignore this resource because it is gated by the mode flag.
resource "aws_route53_record" "website" {
  count = var.manage_dns_in_route53 && local.cloudfront_enabled ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website[0].domain_name
    zone_id                = aws_cloudfront_distribution.website[0].hosted_zone_id
    evaluate_target_health = false
  }
}
