
output "domain_name" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "The generated domain name for the CloudFront distribution."
}