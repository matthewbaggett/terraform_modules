data "docker_registry_image" "image" {
  count = local.is_build == false ? 1 : 0
  name  = var.image
}
locals {
  is_build  = var.build != null
  is_mirror = var.mirror != null

  // Name can be 64 bytes long, including a null byte seemingly, limiting the length to 63.
  service_name = join("-", [
    substr(var.stack_name, 0, 20),
    substr(var.service_name, 0, 63 - 1 - 20),
  ])

  enable_mirror = false // var.mirror != null

  # Calculate the docker image to use
  image = (local.is_build ? docker_registry_image.build[0] : data.docker_registry_image.image[0])
}