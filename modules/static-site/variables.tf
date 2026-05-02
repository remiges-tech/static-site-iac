variable "bucket_name" {
  description = "Name of the S3 bucket that stores the website content"
  type        = string
}

variable "environment" {
  description = "Environment name, such as prod or staging"
  type        = string
  default     = "prod"
}

variable "domain_name" {
  description = "Primary domain name for the website"
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional domain names to include on the certificate and CloudFront aliases"
  type        = list(string)
  default     = []
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID. Required only when manage_dns_in_route53 is true"
  type        = string
  default     = null
}

variable "manage_dns_in_route53" {
  description = "Whether Terraform should manage certificate validation and website DNS records in Route53"
  type        = bool
  default     = true
}

variable "external_dns_validation_record_fqdns" {
  description = "FQDNs of DNS validation records created outside Route53. Used only when manage_dns_in_route53 is false"
  type        = list(string)
  default     = []
}

variable "create_static_site_plugin_policy" {
  description = "Whether to create IAM policy for static site deployment tools to manage S3 content and CloudFront invalidation"
  type        = bool
  default     = false
}
