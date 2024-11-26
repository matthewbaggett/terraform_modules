data "docker_network" "networks" {
  count = var.networks != null ? length(var.networks) : 0
  name  = var.networks[count.index]
}