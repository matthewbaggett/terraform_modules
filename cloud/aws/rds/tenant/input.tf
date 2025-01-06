variable "username" {
  type        = string
  description = "The username for the tenant"
}
variable "password" {
  type        = string
  description = "The password for the tenant"
  default     = null
}
resource "random_password" "password" {
  count   = var.password == null ? 1 : 0
  special = false
  length  = 32
}
variable "database" {
  type        = string
  description = "The database for the tenant"
}
locals {
  username = lower(var.username)
  database = lower(var.database)
  password = try(random_password.password[0].result, var.password)
}
variable "engine" {
  type        = string
  description = "The engine type of the RDS cluster or instance"
}
locals {
  supported_engines = {
    mysql    = ["mysql", "aurora-mysql", "mariadb", ]
    postgres = ["postgresql", "aurora-postgres", ]
  }
  is_mysql    = contains(local.supported_engines.mysql, var.engine)
  is_postgres = contains(local.supported_engines.postgres, var.engine)
}
variable "mysql_binary" {
  type        = string
  description = "The path to the mysql binary"
  default     = "mariadb"
}
variable "postgres_binary" {
  type        = string
  description = "The path to the postgres binary"
  default     = "psql"
}
variable "admin_identity" {
  type = object({
    username = string
    password = string
  })
  description = "The admin identity for the database"
}
variable "debug_path" {
  type        = string
  description = "Path to write debug files to"
  default     = null
}
locals {
  debug_path = var.debug_path != null ? var.debug_path : "${path.root}/.debug/aws/rds/serverless/identities/${local.username}.json"
}