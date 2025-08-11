# This resource defines a custom CloudFront Response Headers Policy to inject security-related headers.
resource "aws_cloudfront_response_headers_policy" "security_headers" {
  name    = "tf-security-headers-policy"
  comment = "A policy that adds baseline security headers for improved security of the static site."

  security_headers_config {
    # Content Security Policy (CSP) restricts what content (scripts, images, etc.) can be loaded.
    # Here 'default-src 'self'' allows content only from the same origin, mitigating XSS attacks.
    content_security_policy {
      content_security_policy = "default-src 'self';"
      override                = true
    }

    # X-Content-Type-Options prevents MIME-type sniffing, ensuring the browser interprets content types as declared.
    content_type_options {
      override = true
    }

    # X-Frame-Options prevents the site from being embedded in iframes, reducing clickjacking risks.
    frame_options {
      frame_option = "DENY"
      override     = true
    }

    # Referrer-Policy: 'no-referrer' prevents the browser from sending the Referer header to external sites.
    # This protects sensitive data in URLs from leaking to third parties.
    referrer_policy {
      referrer_policy = "no-referrer"
      override        = true
    }

    # Strict-Transport-Security (HSTS) forces browsers to connect only via HTTPS and includes subdomains.
    # This helps prevent SSL stripping attacks.
    strict_transport_security {
      access_control_max_age_sec = 63072000
      include_subdomains         = true
      preload                    = true
      override                   = true
    }

    # X-XSS-Protection instructs older browsers to prevent some reflected XSS attacks.
    # Although modern browsers often ignore this, it serves as a minimal additional safeguard.
    xss_protection {
      protection = true
      mode_block = true
      override   = true
      # report_uri could be added if you have a reporting endpoint.
      # report_uri = "https://example.com/report"
    }
  }
}

# This resource defines the CloudFront distribution for the static website hosted on S3.
resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  origin {
    domain_name = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.website.id

    s3_origin_config {
      origin_access_identity = ""
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.website.id
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    # Attach the newly created response headers policy to add security headers on all responses.
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Use the ACM SSL certificate, ensuring TLSv1.2 or higher and sni-only for compatibility.
  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  # Use a custom domain name (alias) for the distribution.
  aliases = [var.domain_name]
}
