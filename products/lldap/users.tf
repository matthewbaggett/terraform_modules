// Add groups
resource "lldap_group" "service_accounts" {
  display_name = "Service Accounts (Terraform Managed)"
}
resource "lldap_group" "user_accounts" {
  display_name = "User Accounts (Terraform Managed)"
}

// Users
resource "random_password" "service_accounts" {
  for_each = { for creds in var.service_accounts : creds.username => creds }
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
resource "random_password" "user_accounts" {
  for_each = { for creds in var.user_accounts : creds.username => creds }
  special  = false
  length   = 32
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

// Relate users to groups
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

// The readonly group seems to have magic permissions, so we need to add service accounts to it
data "lldap_group" "service_readonly" {
  id = 3 // MB: Alas, this is how it be.
}
resource "lldap_member" "service_readonly" {
  for_each = { for creds in var.service_accounts : creds.username => creds }
  group_id = data.lldap_group.service_readonly.id
  user_id  = lldap_user.service_accounts[each.key].id
}


// Add the attributes required for nslcd logins
// @todo: I should make this happen, but its currently making provider unhappy.
/*resource "lldap_user_attribute" "uid" {
  name           = "uidNumber"
  attribute_type = "INTEGER"
}
resource "lldap_user_attribute" "gid" {
  name           = "gidNumber"
  attribute_type = "INTEGER"
  is_list        = true
}
resource "lldap_user_attribute" "homedir" {
  name           = "homeDirectory"
  attribute_type = "STRING"
}
resource "lldap_user_attribute" "shell" {
  name           = "unixShell"
  attribute_type = "STRING"
}
resource "lldap_user_attribute" "ssh_pub_key" {
  name           = "sshPublicKey"
  attribute_type = "STRING"
}
resource "lldap_group_attribute" "gid" {
  name           = "gidNumber"
  attribute_type = "INTEGER"
}*/