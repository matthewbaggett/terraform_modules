// Cache the image locally to a mirror
/*
resource "docker_image" "mirror" {
  count         = local.enable_mirror ? 1 : 0
  name          = data.docker_registry_image.image.name
  pull_triggers = [data.docker_registry_image.image.sha256_digest]
  force_remove  = false
}
resource "docker_tag" "mirror" {
  count        = local.enable_mirror ? 1 : 0
  source_image = docker_image.mirror[0].name
  target_image = var.mirror
}
resource "docker_registry_image" "mirror" {
  count         = local.enable_mirror ? 1 : 0
  depends_on    = [docker_tag.mirror[0]]
  name          = docker_tag.mirror[0].target_image
  keep_remotely = true
}
*/