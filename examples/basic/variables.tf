variable "aws_region" {
  description = "AWS region for most resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile to use from ~/.aws/credentials"
  type        = string
  default     = "default"
}

variable "bucket_name" {
  description = "Name of the S3 bucket that stores the website content"
  type        = string
}

variable "environment" {
  description = "Environment name, such as prod"
  type        = string
  default     = "prod"
}

variable "domain_name" {
  description = "Primary domain name for the website"
  type        = string
}

variable "subject_alternative_names" {
  description = "Additional domain names for the website"
  type        = list(string)
  default     = []
}

variable "manage_dns_in_route53" {
  description = "Whether Terraform should manage DNS in Route53"
  type        = bool
  default     = true
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID. Required only when manage_dns_in_route53 is true"
  type        = string
  default     = null
}

variable "external_dns_validation_record_fqdns" {
  description = "FQDNs of externally created validation records"
  type        = list(string)
  default     = []
}

variable "create_static_site_plugin_policy" {
  description = "Whether to create IAM policy for deployment tools"
  type        = bool
  default     = false
}
