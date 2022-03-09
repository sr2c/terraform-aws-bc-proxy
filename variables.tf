variable "origin_domain" {
  type = string
  description = "The URL for the origin server."
}

variable "logging_bucket" {
  type = string
  default = null
  description = "The domain name of an S3 bucket to store access logs."
}