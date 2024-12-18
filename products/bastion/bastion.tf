module "bastion" {
  source       = "../../docker/service"
  stack_name   = "bastion"
  service_name = "bastion"
  image        = "matthewbaggett/bastion"
  configs = {
    "/usr/etc/ssh/authorized_keys" = "${join("\n", var.authorized_keys)}\n"
    "/etc/motd"                    = "${var.motd}\n"
  }
  placement_constraints = var.placement_constraints
  ports                 = [{ container = 2222, host = var.port }]
  environment_variables = {
    AUTHORIZED_KEYS       = "/usr/etc/ssh/authorized_keys"
    PUBKEY_AUTHENTICATION = true,
    GATEWAY_PORTS         = false,
    PERMIT_TUNNEL         = true,
    X11_FORWARDING        = false,
    TCP_FORWARDING        = true,
    AGENT_FORWARDING      = true,
    LISTEN_PORT           = 2222
  }
}
