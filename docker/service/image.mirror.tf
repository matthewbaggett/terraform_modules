locals {
  is_mirror = var.mirror != null
}
resource "docker_image" "source" {
  for_each      = local.is_mirror ? { "mirror" = {} } : {}
  name          = data.docker_registry_image.image["default"].name
  pull_triggers = [data.docker_registry_image.image["default"].sha256_digest]
  force_remove  = false
}
resource "docker_tag" "retagged" {
  for_each     = local.is_mirror ? { "mirror" = {} } : {}
  source_image = docker_image.source["mirror"].name
  target_image = var.mirror
}
resource "docker_registry_image" "mirror" {
  for_each      = local.is_mirror ? { "mirror" = {} } : {}
  depends_on    = [docker_tag.retagged["mirror"]]
  name          = docker_tag.retagged["mirror"].target_image
  keep_remotely = true
}
