output "credentials" {
  value = {
    username = local.http_username
    password = local.http_password
  }
}