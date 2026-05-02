# static-site module

This module creates the AWS infrastructure for one static website:

- Private S3 bucket for content
- CloudFront distribution with an origin access control
- ACM certificate in us-east-1
- Route53 records when Terraform manages DNS
- DNS validation outputs when DNS is managed elsewhere
- Optional IAM policy for content deployment tools

## Provider requirements

The root module must pass two AWS provider configurations:

- `aws`: main region for most resources
- `aws.us-east-1`: ACM for CloudFront certificates

Example:

```hcl
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "aws" {
  alias   = "us-east-1"
  region  = "us-east-1"
  profile = var.aws_profile
}

module "site" {
  source = "../../modules/static-site"

  bucket_name              = "example-site-bucket"
  domain_name              = "example.com"
  subject_alternative_names = ["www.example.com"]
  environment              = "prod"
  manage_dns_in_route53    = false

  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }
}
```

## DNS modes

### Route53-managed DNS

Set:

```hcl
manage_dns_in_route53 = true
route53_zone_id       = "Z1234567890"
```

Terraform will:
- request the ACM certificate
- create the validation records in Route53
- validate the certificate
- create CloudFront
- create the website alias record in Route53
- keep the S3 bucket private and let CloudFront read it through an origin access control

### External DNS

Set:

```hcl
manage_dns_in_route53 = false
external_dns_validation_record_fqdns = []
```

Apply once to request the certificate and read:

- `certificate_dns_validation_records`

Create those records with your DNS provider, then set:

```hcl
external_dns_validation_record_fqdns = [
  "_example.example.com"
]
```

Apply again to validate the certificate and create CloudFront.

If you want both `example.com` and `www.example.com`, set `domain_name = "example.com"` and `subject_alternative_names = ["www.example.com"]`.

## Choose your publish mode

This module creates infrastructure only. It does not sync a local content directory.
It keeps the S3 bucket private and serves content through CloudFront.

## Pretty URL rewrite

The CloudFront distribution includes a viewer-request function that rewrites clean
URL paths to `index.html` inside the matching folder.

This is needed because the site uses a private S3 REST origin behind CloudFront,
not S3 website hosting. With that setup, CloudFront does not automatically map
requests like `/product-building/` to `/product-building/index.html`.

The static export now uses clean directory URLs, so the rewrite keeps those URLs
working without exposing the old WordPress query-style filenames. It also makes
future exported sites using this module behave the same way without additional
per-site infrastructure changes.

### 1. Simply Static or similar publisher

Set:

```hcl
create_static_site_plugin_policy = true
```

Then apply Terraform:

```bash
terraform apply
```

After the apply completes, read the policy ARN:

```bash
terraform output static_site_plugin_policy_arn
```

Attach that policy to the IAM user or role used by the publishing tool.
Configure the tool with the S3 bucket name and CloudFront distribution ID.
The tool still performs the publish-time AWS calls.

The two outputs publishers use most often are `website_bucket_name` and `cloudfront_distribution_id`.

### 2. Manual sync

Use the AWS CLI or a small script:

```bash
aws s3 sync /path/to/site s3://your-bucket --delete
aws cloudfront create-invalidation --distribution-id DIST_ID --paths "/*"
```
