# basic example

This example shows the intended root-module shape for one static site.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

## Notes

- In Route53 mode, one apply is usually enough.
- In external DNS mode, request the certificate first, create the validation records outside Terraform, then apply again.
- Set `create_static_site_plugin_policy = true` if a publishing tool such as Simply Static should use the generated IAM policy.
- This example creates infrastructure only.
- Choose either manual sync with `aws s3 sync` and CloudFront invalidation, or publish through your tool.
