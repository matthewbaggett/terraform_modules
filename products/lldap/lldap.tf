module "lldap" {
  source                = "../../docker/service"
  enable                = var.enable
  placement_constraints = var.placement_constraints
  stack_name            = var.stack_name
  service_name          = "lldap"
  image                 = "lldap/lldap:${var.lldap_container_version}"
  traefik = {
    domain  = var.domain,
    ssl     = false,
    non-ssl = true,
    port    = 17170
  }
  networks        = concat([module.network], var.networks)
  converge_enable = false
  ports           = var.ports
  start_first     = false
  environment_variables = {
    UID                  = 1000
    GID                  = 1000
    TZ                   = var.timezone
    LLDAP_JWT_SECRET     = nonsensitive(random_password.jwt_secret.result)
    LLDAP_KEY_SEED       = nonsensitive(random_password.key_seed.result)
    LLDAP_LDAP_BASE_DN   = var.base_dn
    LLDAP_LDAP_USER_PASS = local.admin_user_password

    # LDAP over TLS options
    LLDAP_LDAPS_OPTIONS__ENABLED   = true
    LLDAP_LDAPS_OPTIONS__CERT_FILE = "/certs/certfile.crt"
    LLDAP_LDAPS_OPTIONS__KEY_FILE  = "/certs/keyfile.key"

    # Database options
    LLDAP_DATABASE_URL = local.database_url_string

    # SMTP options
    LLDAP_SMTP_OPTIONS__ENABLE_PASSWORD_RESET = var.smtp_enable ? var.enable_password_reset : false
    LLDAP_SMTP_OPTIONS__SERVER                = var.smtp_enable ? var.smtp_server : null
    LLDAP_SMTP_OPTIONS__PORT                  = var.smtp_enable ? var.smtp_port : null
    LLDAP_SMTP_OPTIONS__SMTP_ENCRYPTION       = var.smtp_enable ? var.smtp_encryption : null
    LLDAP_SMTP_OPTIONS__USER                  = var.smtp_enable ? var.smtp_user : null
    LLDAP_SMTP_OPTIONS__PASSWORD              = var.smtp_enable ? var.smtp_password : null
    LLDAP_SMTP_OPTIONS__FROM                  = var.smtp_enable ? var.smtp_from : null
  }
  configs = {
    "/certs/certfile.crt" = tls_self_signed_cert.cert.cert_pem
    "/certs/keyfile.key"  = tls_private_key.key.private_key_pem
  }
}
