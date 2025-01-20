variable "stack_name" {
  description = "The name of the collective stack"
  type        = string
}
variable "volume_name" {
  description = "The name of the volume"
  type        = string
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Resource Tags to apply to this bucket"
}
variable "application" {
  description = "The AWS myApplication to be associated with this cluster"
  type = object({
    arn             = string
    name            = string
    description     = string
    application_tag = map(string)
  })
  default = null
}
variable "ia_lifecycle_policy" {
  default     = "AFTER_30_DAYS"
  description = "The lifecycle policy for transitioning to IA storage"
  type        = string
  validation {
    error_message = "Must be one of AFTER_1_DAY, AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, AFTER_90_DAYS, AFTER_180_DAYS, AFTER_270_DAYS, AFTER_365_DAYS."
    condition     = can(regex("AFTER_(1|7|14|30|60|90|180|270|365)_DAY[S]?", var.ia_lifecycle_policy))
  }
}
variable "archive_lifecycle_policy" {
  default     = "AFTER_60_DAYS"
  description = "The lifecycle policy for transitioning to Archive storage"
  type        = string
  validation {
    error_message = "Must be one of AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, AFTER_90_DAYS, AFTER_180_DAYS, AFTER_270_DAYS, AFTER_365_DAYS."
    condition     = can(regex("AFTER_(7|14|30|60|90|180|270|365)_DAY[S]?", var.archive_lifecycle_policy))
  }
}
variable "origin_security_group_id" {
  description = "The security group ID to allow NFS traffic from"
}
variable "vpc_id" {
  description = "The VPC ID to create the EFS security group in"
}
variable "subnet_ids" {
  type        = list(string)
  description = "The subnet IDs in which the EFS file system will be available."
}