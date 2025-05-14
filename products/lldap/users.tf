resource "lldap_group" "service_accounts" {
  display_name = "Service Accounts (Terraform Managed)"
}
resource "lldap_group" "user_accounts" {
  display_name = "User Accounts (Terraform Managed)"
}
variable "service_accounts" {
  type = list(object({
    username     = string
    email        = string
    display_name = string
  }))
  default = []
}
variable "user_accounts" {
  type = list(object({
    username     = string
    email        = string
    display_name = string
    first_name   = optional(string, "")
    last_name    = optional(string, "")
    avatar       = optional(string, null)
  }))
  default = []
}
resource "random_password" "service_accounts" {
  for_each = { for creds in var.service_accounts : creds.username => creds }
  special  = false
  length   = 32
}
resource "random_password" "user_accounts" {
  for_each = { for creds in var.user_accounts : creds.username => creds }
  special  = false
  length   = 32
}
resource "lldap_user" "service_accounts" {
  for_each     = { for creds in var.service_accounts : creds.username => creds }
  username     = each.value.username
  email        = each.value.email
  password     = random_password.service_accounts[each.key].result
  display_name = each.value.display_name
  first_name   = ""
  last_name    = ""
  avatar       = filebase64("${path.module}/robot.jpg")
}
resource "lldap_user" "user_accounts" {
  for_each     = { for creds in var.user_accounts : creds.username => creds }
  username     = each.value.username
  email        = each.value.email
  password     = random_password.user_accounts[each.key].result
  display_name = each.value.display_name
  first_name   = each.value.first_name
  last_name    = each.value.last_name
  avatar       = each.value.avatar
}
resource "lldap_member" "service_accounts" {
  for_each = { for creds in var.service_accounts : creds.username => creds }
  group_id = lldap_group.service_accounts.id
  user_id  = lldap_user.service_accounts[each.key].id
}
resource "lldap_member" "user_accounts" {
  for_each = { for creds in var.user_accounts : creds.username => creds }
  group_id = lldap_group.user_accounts.id
  user_id  = lldap_user.user_accounts[each.key].id
}
data "lldap_group" "service_readonly" {
  id = 3 // MB: Alas, this is how it be.
}
resource "lldap_member" "service_readonly" {
  for_each = { for creds in var.service_accounts : creds.username => creds }
  group_id = data.lldap_group.service_readonly.id
  user_id  = lldap_user.service_accounts[each.key].id
}