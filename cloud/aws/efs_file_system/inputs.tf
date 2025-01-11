variable "volume_name" {
  type        = string
  description = "The prefix for the efs file system name"
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
}
variable "vpc_id" {
  description = "The VPC ID to use for the EFS security group"
  type        = string
}

variable "users" {
  type        = list(string)
  default     = []
  description = "List of users to generate EFS API keys for. Will be used as the IAM name."
  validation {
    condition     = length(var.users) > 0
    error_message = "At least one user must be specified!"
  }
}
variable "security_group_ids" {
  type        = list(string)
  description = "The security group ids to apply to the task"
  default     = []
}
variable "origin_security_group_id" {
  type        = string
  description = "The security group id of the origin security group. This is the security group that contains devices that will be allowed to access the EFS file system."
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

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet IDs in which the EFS file system will be available."
}