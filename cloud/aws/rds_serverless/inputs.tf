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
  description = "The database engine to use. This must be either aurora-mysql or aurora-postgresql"
  default     = "aurora-mysql"
  validation {
    error_message = "Must be either aurora-mysql or aurora-postgresql"
    condition     = contains(["aurora-mysql", "aurora-postgresql"], var.engine)
  }
}
locals {
  is_mysql        = var.engine == "aurora-mysql"
  is_postgres     = var.engine == "aurora-postgresql"
  supported_mysql = ["5.7", "8.0"]
  supported_postgres = [
    "11.9", "11.21",
    "12.9", "12.11", "12.12", "12.13", "12.14", "12.15", "12.16", "12.17", "12.18", "12.19", "12.20", "12.22",
    "13.7", "13.8", "13.9", "13.10", "13.11", "13.12", "13.12", "13.13", "13.14", "13.15", "13.16", "13.18",
    "14.3", "14.4", "14.5", "14.6", "14.7", "14.8", "14.9", "14.10", "14.11", "14.12", "14.13", "14.15",
    "15.2", "15.3", "15.4", "15.5", "15.6", "15.7", "15.8", "15.10",
    "16.1", "16.2", "16.3", "16.4", "16.6",
  ]
  engines_supporting_local_write_forwarding = {
    "aurora-mysql" = ["8.0"]
    "aurora-postgresql" = [
      "14.13", "14.15",
      "15.8", "15.10",
      "16.4", "16.6",
    ]
  }
  # MB: This is a hack until I get my patch into terraform's aws provider: https://github.com/hashicorp/terraform-provider-aws/pull/40700
  supports_local_write_forwarding = (
    local.is_mysql && contains(local.engines_supporting_local_write_forwarding.aurora-mysql, local.engine_version) ||
    local.is_postgres && contains(local.engines_supporting_local_write_forwarding.aurora-postgresql, local.engine_version)
  )
}
variable "engine_version" {
  type    = string
  default = null
  validation {
    error_message = "If the engine is mysql_aurora, the engine_version must be one of ${join(", ", local.supported_mysql)}."
    condition     = local.is_mysql ? contains(local.supported_mysql, var.engine_version) : true
  }
  validation {
    error_message = "If the engine is aurora-postgresql, the engine_version must be one of ${join(", ", local.supported_postgres)}."
    condition     = local.is_postgres ? contains(local.supported_postgres, var.engine_version) : true
  }
}
locals {
  engine_version = var.engine_version != null ? var.engine_version : "8.0"
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

locals {
  scaling = merge(var.scaling, {
    min_capacity = local.is_mysql && var.engine_version == "5.7" && var.scaling.min_capacity == 0 ? 1 : var.scaling.min_capacity
  })
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

