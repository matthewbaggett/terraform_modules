resource "docker_registry_image" "build" {
  count         = local.is_build ? 1 : 0
  name          = docker_image.build[0].name
  keep_remotely = true
}
resource "docker_image" "build" {
  count = local.is_build ? 1 : 0
  name  = var.image
  build {
    context = var.build.context
  }
  force_remove = true
}