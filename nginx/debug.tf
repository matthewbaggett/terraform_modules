resource "local_file" "configs" {
  content  = yamlencode(var.configs)
  filename = "${path.module}/debug/config.yaml"
}
