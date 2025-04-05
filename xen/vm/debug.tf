resource "local_file" "cloudinit" {
  filename        = "${path.root}/.debug/cloudinit/${local.hostname}/cloud-init.yaml"
  content         = module.cloudinit.user_data_raw
  file_permission = "0600"
}
resource "local_file" "network" {
  filename        = "${path.root}/.debug/cloudinit/${local.hostname}/networking.cfg"
  content         = yamlencode(local.network_config)
  file_permission = "0600"
}