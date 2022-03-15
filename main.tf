
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

resource "aws_cloudwatch_metric_alarm" "high_bandwidth" {
  alarm_name = "bandwidth-out-high-${var.origin_domain}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name = "BytesDownloaded"
  namespace = "AWS/CloudFront"
  period = "3600"
  statistic = "Sum"
  threshold = var.max_transfer_per_hour
  alarm_description = "Alerts when bandwidth out exceeds specified threshold in an hour"
  actions_enabled = "true"
  alarm_actions = [var.sns_topic_arn]
  dimensions = {
    DistributionId = aws_cloudfront_distribution.this.id
  }

  tags = module.this.tags
}

resource "aws_cloudwatch_metric_alarm" "low_bandwidth" {
  alarm_name = "bandwidth-out-low-${var.origin_domain}"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "6"
  metric_name = "BytesDownloaded"
  namespace = "AWS/CloudFront"
  period = "3600"
  statistic = "Sum"
  threshold = "0"
  alarm_description = "Alerts when bandwidth out is zero for six hours"
  actions_enabled = "true"
  alarm_actions = [var.sns_topic_arn]
  treat_missing_data = "breaching"
  dimensions = {
    DistributionId = aws_cloudfront_distribution.this.id
  }

  tags = module.this.tags
}
