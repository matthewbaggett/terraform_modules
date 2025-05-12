resource "random_password" "admin_user_password" {
  count   = var.admin_user_password == null ? 1 : 0
  length  = 32
  special = false
}
locals {
  admin_user_password = var.admin_user_password == null ? nonsensitive(random_password.admin_user_password[0].result) : var.admin_user_password
}
resource "random_password" "jwt_secret" {
  length  = 32
  special = false
}
resource "random_password" "key_seed" {
  length  = 32
  special = false
}