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
  description = "The lifecycle policy for transitioning to IA storage"
  type        = string
  validation {
    error_message = "Must be one of AFTER_1_DAY, AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, AFTER_90_DAYS, AFTER_180_DAYS, AFTER_270_DAYS, AFTER_365_DAYS."
    condition     = can(regex("AFTER_(1|7|14|30|60|90|180|270|365)_DAY[S]?", var.archive_lifecycle_policy))
  }
}
variable "create_fs" {
  default     = true
  type        = bool
  description = "Create the EFS file system, or let something else do it?"
}
resource "aws_efs_file_system" "volume" {
  count          = var.create_fs ? 1 : 0
  creation_token = var.volume_name
  lifecycle_policy {
    transition_to_ia                    = var.ia_lifecycle_policy
    transition_to_archive               = var.archive_lifecycle_policy
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }
  tags = merge(local.tags, {
    Name = var.volume_name
  })
  encrypted       = true
  throughput_mode = "elastic"
}

resource "aws_efs_access_point" "access_point" {
  count          = var.create_fs ? 1 : 0
  file_system_id = aws_efs_file_system.volume[0].id
  root_directory {
    path = "/"
  }
  tags = merge(local.tags, {
    Name = "${var.volume_name}-access-point"
  })
}