locals {
  registry_users = {
    for user in var.registry_users : user.username =>
    (user.password == null ? nonsensitive(random_password.registry_users[user.username].result) : user.password)
  }
  # For each user, construct a htpasswd line
  registry_user_pass_pairs = [
    for user, pass in local.registry_users : "${user}:${htpasswd_password.registry_users[user].bcrypt}"
  ]
  registry_htpasswd = "${join("\n", local.registry_user_pass_pairs)}\n"
}
resource "random_password" "registry_users" {
  for_each = { for registry_user in var.registry_users : registry_user.username => registry_user.username }
  length   = 32
  special  = false
}
resource "random_password" "salt" {
  for_each = random_password.registry_users
  length   = 8
  special  = false
}
resource "htpasswd_password" "registry_users" {
  for_each = random_password.registry_users
  password = each.value.result
  salt     = random_password.salt[each.key].result
}
resource "docker_config" "docker_registry_htpasswd" {
  name = "docker-registry-htpasswd-${replace(plantimestamp(), ":", ".")}"
  data = base64encode(local.registry_htpasswd)
  lifecycle {
    ignore_changes        = [name]
    create_before_destroy = true
  }
}
resource "local_file" "docker_registry_htpasswd" {
  content         = local.registry_htpasswd
  filename        = "${path.root}/.debug/docker-registry/htpasswd"
  file_permission = "0600"
}