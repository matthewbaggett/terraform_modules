output "id" {
  value = docker_config.config.id
}
output "name" {
  value = docker_config.config.name
}
output "checksum" {
  value = sha512(join("", [
    docker_config.config.id,
    docker_config.config.name,
    docker_config.config.data,
  ]))
}