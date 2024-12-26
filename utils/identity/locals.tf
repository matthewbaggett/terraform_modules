locals {
  username_words = var.username_words != null ? var.username_words : floor(var.username_max_length / 3)
  username       = var.username != null ? var.username : random_pet.username[0].id
  password       = var.password != null ? sensitive(var.password) : random_password.password[0].result
}