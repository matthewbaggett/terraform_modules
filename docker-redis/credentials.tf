resource "random_password" "auth" {
  length  = 16
  special = false
}

locals {
  auth = var.auth != null ? var.auth : nonsensitive(random_password.auth.result)
}