variable "instance_name" {
  type        = string
  description = "The name of the RDS serverless instance"
  default     = "serverless-multitennant"
}
locals {
  sanitised_name = lower(replace(var.instance_name, "[^a-zA-Z0-9]", "-"))
}
variable "tenants" {
  type = map(object({
    username = string
    database = string
    active   = optional(bool, true)
  }))
  default = null
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

variable "engine" {
  type        = string
  description = "The database engine to use"
  default     = "aurora-mysql"
  validation {
    error_message = "Must be either aurora-mysql or aurora-postgresql"
    condition     = contains(["aurora-mysql", "aurora-postgresql"], var.engine)
  }
}

variable "scaling" {
  type = object({
    max_capacity = optional(number, 1)
    min_capacity = optional(number, 0)
  })
  default = {
    max_capacity = 1
    min_capacity = 0
  }
  validation {
    error_message = "max_capacity must be greater or equal to min_capacity."
    condition     = var.scaling.max_capacity >= var.scaling.min_capacity
  }
  validation {
    error_message = "min_capacity must be one of 0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 384."
    condition     = contains([0, 1, 2, 4, 8, 16, 32, 64, 128, 256, 384], var.scaling.min_capacity)
  }
  validation {
    error_message = "max_capacity must be one of 1, 2, 4, 8, 16, 32, 64, 128, 256, 384."
    condition     = contains([1, 2, 4, 8, 16, 32, 64, 128, 256, 384], var.scaling.max_capacity)
  }
}

variable "backup_window" {
  type        = string
  description = "The daily time range during which automated backups are created if automated backups are enabled."
  default     = "03:00-05:00"
}
variable "backup_retention_period_days" {
  type    = number
  default = 30
  validation {
    error_message = "backup_retention_period_days must be between 1 and 35."
    condition     = var.backup_retention_period_days >= 1 && var.backup_retention_period_days <= 35
  }
}
variable "skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted."
  default     = false
}

variable "enable_performance_insights" {
  type    = bool
  default = false
}

variable "bastion" {
  description = "The ssh bastion to use for creating the database"
  type = object({
    host        = string
    user        = optional(string)
    password    = optional(string)
    private_key = optional(string)
  })
}