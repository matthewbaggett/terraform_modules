
# Outputs
output "registry_users" {
  value = {
    for user in local.registry_users : user => nonsensitive(random_password.registry_users[user].result)
  }
}
