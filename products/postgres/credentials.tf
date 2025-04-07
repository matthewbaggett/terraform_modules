resource "random_pet" "username" {
  count  = var.username != null ? 0 : 1
  length = 2
}
resource "random_password" "password" {
  count   = var.password != null ? 0 : 1
  length  = 32
  special = false
}
resource "random_pet" "database" {
  count  = var.database != null ? 0 : 1
  length = 2
}
locals {
  username = var.username != null ? var.username : replace(random_pet.username[0].id, "-", "")
  password = var.password != null ? var.password : nonsensitive(random_password.password[0].result)
  database = var.database != null ? var.database : replace(random_pet.database[0].id, "-", "")
}