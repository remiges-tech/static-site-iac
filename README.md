# static-site-iac

Reusable Terraform for one static website on AWS.

## What is in this repo

- `modules/static-site` - the reusable Terraform module
- `examples/basic` - a minimal root stack that calls the module

This repo no longer contains a standalone top-level site stack.
Use the module from another repo or from the example root stack.

## Module summary

The module creates:

- S3 bucket for site content
- CloudFront distribution
- ACM certificate in `us-east-1`
- Route53 validation and website records when DNS is managed in Route53
- DNS validation outputs when DNS is managed elsewhere
- Optional IAM policy for deployment tools

## Local development

Use the example root stack:

```bash
cd examples/basic
cp terraform.tfvars.example terraform.tfvars
terraform init -backend=false
terraform plan
terraform apply
```

## Reuse from another repo

Point a root stack at the module, ideally with a Git source pinned to a tag:

```hcl
module "site" {
  source = "git::https://github.com/remiges-tech/static-site-iac.git//modules/static-site?ref=v0.1.0"
}
```

For local sibling development, a relative path also works.

## Content deployment

Terraform creates infrastructure only.
Choose one publish path:

- Manual sync: use `aws s3 sync` and a CloudFront invalidation.
- Simply Static or a similar publisher: set `create_static_site_plugin_policy = true` and attach the generated policy to the publishing identity.

See:
- `modules/static-site/README.md`
- `examples/basic/README.md`
