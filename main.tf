
resource "aws_cloudfront_distribution" "this" {
  comment = "CDN for ${var.origin_domain}"
  enabled = true
  is_ipv6_enabled = true

  origin {
    domain_name = var.origin_domain
    origin_id   = "Custom-${var.origin_domain}"
    connection_attempts = 3
    connection_timeout = 10

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "Custom-${var.origin_domain}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      headers = []
      query_string = true
      cookies {
        forward = "none"
        whitelisted_names = []
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  dynamic "logging_config" {
    for_each = var.logging_bucket == null ? [] : [1]
    content {
      bucket = var.logging_bucket
      include_cookies = false
    }
  }

  tags = module.this.tags
}