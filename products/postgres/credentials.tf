resource "random_pet" "username" {
  length = 2
}
resource "random_password" "password" {
  length  = 32
  special = false
}
resource "random_pet" "database" {
  length = 2
}
locals {
  username = var.username != null ? var.username : replace(random_pet.username.id, "-", "")
  password = var.password != null ? var.password : nonsensitive(random_password.password.result)
  database = var.database != null ? var.database : replace(random_pet.database.id, "-", "")
}