resource "random_pet" "user" {
  length    = 2
  separator = ""
}
resource "random_password" "password" {
  length  = 32
  special = true
}
resource "random_password" "key" {
  length  = 32
  special = false
}