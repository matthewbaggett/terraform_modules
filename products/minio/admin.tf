resource "random_pet" "minio_admin_user" {
  length    = 2
  separator = ""
}
resource "random_password" "minio_admin_password" {
  length  = 32
  special = false
}