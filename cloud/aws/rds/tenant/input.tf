variable "vpc_id" {
  type        = string
  description = "VPC ID"
}
variable "cluster_id" {
  type        = string
  description = "The cluster identifier"
}
data "aws_rds_cluster" "cluster" {
  cluster_identifier = var.cluster_id
}
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
  validation {
    error_message = "Engine must be one of 'aurora-postgres' or 'aurora-mysql'"
    condition     = var.engine == "aurora-postgres" || var.engine == "aurora-mysql"
  }
}
locals {
  is_mysql    = var.engine == "aurora-mysql"
  is_postgres = var.engine == "aurora-postgres"
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