variable "volume_name" {
  type        = string
  description = "The prefix for the efs file system name"
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