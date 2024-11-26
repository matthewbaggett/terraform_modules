output "source" {
  value = docker_volume.volume.id
}
output "volume" {
  value = docker_volume.volume
}