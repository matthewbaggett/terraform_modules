variable "bucket_name_prefix" {
  type        = string
  description = "The prefix for the bucket name"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Resource Tags to apply to this bucket"
}
locals {
  tags = merge({

  }, var.tags)
}
variable "users" {
  type        = list(string)
  default     = []
  description = "List of users to generate S3 API keys for. Will be used as the IAM name."
  validation {
    condition     = length(var.users) > 0
    error_message = "At least one user must be specified!"
  }
}