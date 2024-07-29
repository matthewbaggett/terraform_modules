resource "docker_network" "instance" {
  name   = var.stack_name
  driver = "overlay"
  labels {
    label = "com.docker.stack.namespace"
    value = var.stack_name
  }
}