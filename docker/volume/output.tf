output "source" {
  value = docker_volume.volume.id
}
output "volume" {
  value = docker_volume.volume
}

output "id" {
  value = docker_volume.volume.id
}
output "name" {
  value = docker_volume.volume.name
}
output "driver" {
  value = docker_volume.volume.driver
}
output "driver_opts" {
  value = docker_volume.volume.driver_opts
}