module "tunnel" {
  source  = "flaupretre/tunnel/ssh"
  version = "2.3.0"

  target_host = local.db_tunnel_remote.host
  target_port = local.db_tunnel_remote.port

  gateway_host = var.bastion.host
  gateway_port = var.bastion.port
  gateway_user = var.bastion.username
  ssh_cmd      = "ssh -F none -o StrictHostKeyChecking=no -o PasswordAuthentication=no -i ${var.bastion.private_key_file}"
}