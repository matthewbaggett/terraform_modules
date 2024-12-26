variable "admin_username" {
  type    = string
  default = null
}
resource "random_pet" "admin_user" {
  count     = var.admin_username == null ? 1 : 0
  separator = "_"
}
variable "admin_password" {
  type    = string
  default = null
}
resource "random_password" "admin_pass" {
  count   = var.admin_username == null ? 1 : 0
  special = false
  length  = 32
}
locals {
  admin_username = coalesce(var.admin_username, random_pet.admin_user[0].id)
  admin_password = nonsensitive(coalesce(var.admin_password, random_password.admin_pass[0].result))
}