resource "docker_volume" "volume" {
  for_each = var.volumes
  name = lower(join("-", [
    substr(var.stack_name, 0, 20),
    substr(var.service_name, 0, 20),
    substr(replace(trim(each.key, "/"), "/", "-"), 0, 20)
  ]))
}