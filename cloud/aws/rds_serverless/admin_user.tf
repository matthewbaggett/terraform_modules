variable "admin_user" {
  type = object({
    username = string
    password = string
  })
  default = null
}
resource "random_pet" "admin_user" {
  count     = var.admin_user == null ? 1 : 0
  separator = "-"
}
resource "random_password" "admin_user" {
  length  = 32
  special = false
}
locals {
  admin_user = var.admin_user != null ? var.admin_user : {
    username = random_pet.admin_user.id
    password = random_password.admin_user.result
  }
}