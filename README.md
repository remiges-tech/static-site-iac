# Static Website Infrastructure

This Terraform configuration sets up AWS infrastructure for hosting a static website with HTTPS and CDN support.

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version >= 1.2.0)
- A registered domain name in Route53

## Infrastructure Components

- S3 bucket for website hosting
  - Public read access
  - Versioning enabled
  - Configured for static website hosting
- CloudFront distribution for content delivery
- SSL certificate via AWS Certificate Manager
- Route53 DNS records
- S3 backend for Terraform state with DynamoDB locking

## Initial Setup

1. Set up the Terraform backend:
   ```bash
   # Copy and configure the backend configuration
   cp backend.tf.example backend.tf
   ```
   Update backend.tf with:
   - Your S3 bucket name for state storage
   - Your preferred AWS region
   - Your DynamoDB table name for state locking
   - Your AWS profile name

2. Copy and configure the variables:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   Update terraform.tfvars with:
   - `aws_region`: AWS region for most resources
   - `bucket_name`: Name for your S3 bucket
   - `environment`: Environment name (e.g., prod)
   - `domain_name`: Your website domain
   - `route53_zone_id`: Your Route53 zone ID
   - `aws_profile`: Your AWS profile name

## Deployment

1. Initialize Terraform with the backend:
   ```bash
   terraform init
   ```

2. Review and apply the changes:
   ```bash
   terraform plan
   terraform apply
   ```

3. Upload your website files to the created S3 bucket:
   - `index.html` as your main page
   - `error.html` as your error page
   - Any other website assets

## Static Site Plugin Support

This infrastructure can optionally create an IAM policy suitable for static site plugins (like SimplyStatic) that need to:
- Upload static files to the S3 bucket
- Delete objects from the S3 bucket
- Create CloudFront invalidations

To enable this feature, set in your `terraform.tfvars`:
```hcl
create_static_site_plugin_policy = true
```

The policy ARN will be output as `static_site_plugin_policy_arn`. You can attach this policy to any IAM user or role that needs to manage the static site content.

If you prefer to manage these permissions outside of this Terraform configuration, leave `create_static_site_plugin_policy` as `false` or omit it.

The policy, when created, provides the following permissions:
- S3 actions: PutObject, GetObject, DeleteObject, ListBucket
- CloudFront actions: CreateInvalidation, GetInvalidation, ListInvalidations

## Important Notes

- SSL certificate is created in us-east-1 (required for CloudFront)
- CloudFront distribution typically takes 10-20 minutes to deploy
- Website will be accessible via HTTPS only (HTTP redirects to HTTPS)
- CloudFront is configured with Price Class 100 (US, Canada, Europe)
- Sensitive configuration files (backend.tf, terraform.tfvars) are gitignored
- Example files are provided as templates

## Cleanup

To remove all created resources:
```bash
terraform destroy
