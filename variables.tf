variable "origin_domain" {
  type = string
  description = "The URL for the origin server."
}

variable "logging_bucket" {
  type = string
  default = null
  description = "The domain name of an S3 bucket to store access logs."
}

variable "max_transfer_per_hour" {
  type = string
  default = "2147483648"
  description = "The maximum number of bytes that can be sent out per hour."
}

variable "sns_topic_arn" {
  type = string
  default = null
  description = "The ARN of an SNS topic to send notifications to."
}
