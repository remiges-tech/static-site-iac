variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., prod, staging, dev)"
  type        = string
  default     = "prod"
}

variable "domain_name" {
  description = "Domain name for the website"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "terraform_state_bucket" {
  description = "Name of the S3 bucket for storing Terraform state"
  type        = string
}

variable "terraform_state_dynamodb_table" {
  description = "Name of the DynamoDB table for Terraform state locking"
  type        = string
  default     = "terraform-state-lock"
}

variable "aws_profile" {
  description = "AWS profile to use from ~/.aws/credentials"
  type        = string
  default     = "default"
}

variable "create_static_site_plugin_policy" {
  description = "Whether to create IAM policy for static site plugins (like SimplyStatic) to manage S3 content and CloudFront invalidation"
  type        = bool
  default     = false
}
