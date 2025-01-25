variable "username" {
  type        = string
  description = "The username to use for the service."
  default     = null
}
variable "password" {
  type        = string
  description = "The password to use for the service."
  default     = null
}
resource "random_pet" "username" {
  count     = var.username == null ? 1 : 0
  length    = 2
  separator = ""
}
resource "random_string" "password" {
  count   = var.username == null ? 1 : 0
  length  = 32
  special = false
}
locals {
  username = var.username != null ? var.username : random_pet.username[0].id
  password = var.password != null ? var.password : nonsensitive(random_string.password[0].result)
}