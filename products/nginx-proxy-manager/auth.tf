variable "admin_email" {
  type        = string
  description = "The email address to use for the admin user."
}
variable "admin_password" {
  default     = null
  type        = string
  description = "The password to use for the admin user."
}

resource "random_password" "password" {
  count   = var.admin_password == null ? 1 : 0
  length  = 32
  special = false
}

locals {
  admin_email    = var.admin_email
  admin_password = var.admin_password == null ? random_password.password[0].result : var.admin_password
}