locals {
  http_username = var.http_username != null ? var.http_username : var.downloader
  http_password = var.http_password != null ? var.http_password : nonsensitive(random_password.warrior_password[0].result)
}
