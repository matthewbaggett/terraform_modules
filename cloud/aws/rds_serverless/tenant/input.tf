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
variable "app_name" {
  type        = string
  description = "The application name"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
variable "aws_profile" {
  type        = string
  description = "AWS profile to use for generating RDS auth token"
  default     = null
}
variable "is_active" {
  type    = bool
  default = true
}
variable "super_user_iam_role_name" {
  type    = string
  default = null
}
variable "engine" {
  type        = string
  description = "The engine type of the RDS cluster"
  validation {
    error_message = "Engine must be one of 'aurora-postgres' or 'aurora-mysql'"
    condition     = var.engine == "aurora-postgres" || var.engine == "aurora-mysql"
  }
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
variable "admin_username" {
  type        = string
  description = "The admin user for the database"
}
variable "admin_password" {
  type        = string
  description = "The admin password for the database"
}