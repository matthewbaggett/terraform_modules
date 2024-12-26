resource "random_pet" "username" {
  count     = var.username == null ? 1 : 0
  length    = var.username_words
  separator = var.username_separator
}
resource "random_password" "password" {
  count            = var.password == null ? 1 : 0
  length           = var.password_length
  special          = true
  override_special = var.password_special_characters
}
