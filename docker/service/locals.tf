data "docker_registry_image" "image" {
  count = local.is_build == false ? 1 : 0
  name  = var.image
}
locals {
  // Name can be 64 bytes long, including a null byte seemingly, limiting the length to 63.
  service_name = join("-", [
    substr(var.stack_name, 0, 20),
    substr(var.service_name, 0, 63 - 1 - 20),
  ])
  # Calculate the docker image to use
  image = (
    local.is_build
    ? docker_image.build[0].name
    : (
      local.is_mirror
      ? docker_registry_image.mirror[0].name
      : data.docker_registry_image.image[0].name
    )
  )
  image_fully_qualified = (
    local.is_build
    ? docker_image.build[0].name
    : (
      local.is_mirror
      ? "${docker_registry_image.mirror[0].name}@${docker_registry_image.mirror[0].sha256_digest}"
      : "${data.docker_registry_image.image[0].name}@${data.docker_registry_image.image[0].sha256_digest}"
    )
  )
}