variable "origin_domain" {
  type = string
  description = "The URL for the origin server."
}

variable "bypass_token" {
  type = string
  default = null
  description = "A value to set for a Bypass-Rate-Limit-Token header to be sent to the origin with all requests."
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

variable "low_bandwidth_alarm" {
  type = bool
  default = true
  description = "Whether the low bandwidth alarm should be created."
}
