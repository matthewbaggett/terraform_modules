data "docker_registry_image" "image" {
  for_each = !local.is_build ? { "default" = {} } : {}
  name     = var.image
}