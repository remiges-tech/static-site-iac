# Request the ACM certificate here.
# dns.tf owns the validation flow so this same request works in both DNS modes.
resource "aws_acm_certificate" "cert" {
  provider                  = aws.us-east-1
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
