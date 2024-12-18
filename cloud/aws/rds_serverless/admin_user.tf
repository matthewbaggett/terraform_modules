variable "admin_username" {
  type    = string
  default = null
}
resource "random_pet" "admin_user" {
  count     = var.admin_username == null ? 1 : 0
  separator = "_"
}
locals {
  admin_username = coalesce(var.admin_username, random_pet.admin_user[0].id)
  admin_token    = ""
}