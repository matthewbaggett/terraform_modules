module "tester" {
  source                = "../../docker/service"
  enable                = var.enable
  placement_constraints = var.placement_constraints
  stack_name            = var.stack_name
  service_name          = "lldap-tester"
  image                 = "${var.lldap_container_image}:${var.lldap_container_version}"
  networks              = [module.network]
  converge_enable       = false
  command               = ["/bin/sh", "/run.sh"]
  environment_variables = {
    LLDAP_ENDPOINT = local.ldaps_endpoint
  }
  configs = {
    "/usr/local/share/ca-certificates/our-self-signed-cert.pem" = tls_self_signed_cert.ca_cert.cert_pem
    "/run.sh"                                                   = <<EOF
#!/bin/sh
set -e
set -x
apk add --no-cache openldap-clients ca-certificates
update-ca-certificates
ldapwhoami -x -H ldaps://${local.ldaps_endpoint} -D "${var.admin_username}" -w "${local.admin_password}"
sleep 300
EOF
  }
}
