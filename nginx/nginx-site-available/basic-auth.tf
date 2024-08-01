# Generate auth bits
resource "random_password" "salt" {
  count   = var.basic_auth != null ? 1 : 0
  length  = 8
  special = false
}
resource "htpasswd_password" "hash" {
  count    = var.basic_auth != null ? 1 : 0
  password = var.basic_auth.password
  salt     = random_password.salt[0].result
}
# Auth file
resource "docker_config" "auth" {
  count = var.basic_auth != null ? 1 : 0
  name  = join(".", [var.config_prefix, "auth", var.hostname, random_id.config_instance.id])
  data  = base64encode(local.auth)
}
resource "local_file" "auth" {
  count    = var.basic_auth != null ? 1 : 0
  content  = local.auth
  filename = "${path.root}/.debug/nginx/${local.filenames.auth}"
}
