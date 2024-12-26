locals {
  is_mirror = var.mirror != null
}
resource "docker_image" "source" {
  for_each      = local.is_mirror ? { "mirror" = {} } : {}
  name          = data.docker_registry_image.image[0].name
  pull_triggers = [data.docker_registry_image.image[0].sha256_digest]
  force_remove  = false
}
resource "docker_tag" "retagged" {
  for_each     = local.is_mirror ? { "mirror" = {} } : {}
  source_image = docker_image.source[0].name
  target_image = var.mirror
}
resource "docker_registry_image" "mirror" {
  for_each      = local.is_mirror ? { "mirror" = {} } : {}
  depends_on    = [docker_tag.retagged[0]]
  name          = docker_tag.retagged[0].target_image
  keep_remotely = true
}
