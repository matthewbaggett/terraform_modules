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
  description = "The database engine to use. This must be either aurora-mysql or aurora-postgresql"
  default     = "mysql"
  validation {
    error_message = "Must be either ${join(" or ", local.supported_engines)}."
    condition     = contains(local.supported_engines, var.engine)
  }
}
locals {
  supported_engines = ["mysql", "postgresql", "mariadb", ]
  is_mysql          = var.engine == "mysql"
  is_postgres       = var.engine == "postgresql"
  is_mariadb        = var.engine == "mariadb"
}
variable "engine_version" {
  type    = string
  default = null
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

