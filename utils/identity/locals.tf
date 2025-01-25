locals {
  username       = var.username != null ? var.username : random_pet.username[0].id
  password       = var.password != null ? nonsensitive(var.password) : nonsensitive(random_password.password[0].result)
}