resource "local_file" "cloudinit" {
  filename        = "${path.root}/.debug/cloudinit/${var.cluster_name}/${var.hostname}/cloud-init.yaml"
  content         = local.config
  file_permission = "0600"
}