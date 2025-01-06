resource "random_password" "password" {
  for_each = { for user in var.users : user.username => user }
  length   = 32
  special  = false
}
resource "random_uuid" "uuid" {
  for_each = { for user in var.users : user.username => user }
}
locals {
  staticClients = []
  staticPasswords = [
    for user in var.users : {
      email    = user.email
      username = user.username
      hash     = nonsensitive(bcrypt(random_password.password[user.username].result))
      userID   = random_uuid.uuid[user.username].result
    }
  ]
}