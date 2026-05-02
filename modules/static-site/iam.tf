resource "aws_iam_policy" "static_site_plugin" {
  # Wait until CloudFront exists so the policy can include the distribution ARN.
  count = var.create_static_site_plugin_policy && local.cloudfront_enabled ? 1 : 0

  name        = "static-site-plugin-${var.environment}"
  description = "Policy for static site plugins to manage S3 content and CloudFront invalidation"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.website.arn,
          "${aws_s3_bucket.website.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetInvalidation",
          "cloudfront:ListInvalidations"
        ]
        Resource = aws_cloudfront_distribution.website[0].arn
      }
    ]
  })

  tags = {
    Environment = var.environment
  }
}
