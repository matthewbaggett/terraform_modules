variable "instance_name" {
  type        = string
  description = "The name of the RDS serverless instance"
  default     = "serverless-multitennant"
}
locals {
  sanitised_name = replace(replace(lower(var.instance_name), "[^a-z0-9A-Z-]", "-"), " ", "-")
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
  validation {
    error_message = "Must be one of: ${join(", ", local.supported_engines)}."
    condition     = contains(local.supported_engines, var.engine)
  }
}
locals {
  is_mysql    = var.engine == "mysql"
  is_postgres = var.engine == "postgresql"
  is_mariadb  = var.engine == "mariadb"
  port        = local.is_mysql ? 3306 : local.is_postgres ? 5432 : local.is_mariadb ? 3306 : 0
}
variable "engine_version" {
  type    = string
  default = null
  validation {
    error_message = "If the engine is mysql_aurora, the engine_version must be one of ${join(", ", local.supported_mysql)}."
    condition     = var.engine_version == null ? true : (local.is_mysql ? contains(local.supported_mysql, var.engine_version) : true)
  }
  validation {
    error_message = "If the engine is aurora-postgresql, the engine_version must be one of ${join(", ", local.supported_postgres)}."
    condition     = var.engine_version == null ? true : (local.is_postgres ? contains(local.supported_postgres, var.engine_version) : true)
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

