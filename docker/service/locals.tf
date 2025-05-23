locals {
  // Name can be 64 bytes long, including a null byte seemingly, limiting the length to 63.
  service_name = join("-", [
    substr(var.stack_name, 0, 20),
    substr(var.service_name, 0, 63 - 1 - 20),
  ])
  # Calculate the docker image to use
  image = (
    local.is_build
    ? docker_image.build["build"].name
    : (
      local.is_mirror
      ? docker_registry_image.mirror["mirror"].name
      : try(data.docker_registry_image.image["default"].name, null)
    )
  )
  image_fully_qualified = (
    local.is_build
    ? "${docker_registry_image.build["build"].name}@${docker_registry_image.build["build"].sha256_digest}"
    : (
      local.is_mirror
      ? "${docker_registry_image.mirror["mirror"].name}@${docker_registry_image.mirror["mirror"].sha256_digest}"
      : try("${data.docker_registry_image.image["default"].name}@${data.docker_registry_image.image["default"].sha256_digest}", null)
    )
  )
  network_ids = distinct([for network in concat(var.networks, [try(data.docker_network.traefik[0], null)]) : network.id if network != null])
}