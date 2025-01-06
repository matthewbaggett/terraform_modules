variable "stack_name" {
  description = "The name of the collective stack"
  type        = string
}
variable "volume_name" {
  description = "The name of the volume"
  type        = string
}

variable "bucket_name" {
  description = "Override the generated name of the S3 bucket to create"
  type        = string
  default     = null
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS Resource Tags to apply to this bucket"
}
variable "image_efs_plugin" {
  type        = string
  description = "The docker image to use for the service."
  default     = "rexray/efs:0.11.4"
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

variable "security_group_ids" {
  type        = list(string)
  description = "The security group ids to apply to the task"
}