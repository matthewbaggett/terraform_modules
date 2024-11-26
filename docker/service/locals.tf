locals {
  // Name can be 64 bytes long, including a null byte seemingly, limiting the length to 63.
  service_name = join("-", [
    substr(var.stack_name, 0, 20),
    substr(var.service_name, 0, 63 - 1 - 20),
  ])

  enable_mirror = false // var.mirror != null

  # Calculate the docker image to use
  #image = local.enable_mirror ? "${docker_registry_image.mirror[0].name}@${docker_registry_image.mirror[0].sha256_digest}" : "${data.docker_registry_image.image.name}@${data.docker_registry_image.image.sha256_digest}"
  image = "${data.docker_registry_image.image.name}@${data.docker_registry_image.image.sha256_digest}"
}