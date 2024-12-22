output "network" {
  value = docker_network.instance
}
output "name" {
  value = docker_network.instance.name
}
output "id" {
  value = docker_network.instance.id
}