

module "lldap" {
  source                = "../../docker/service"
  enable                = var.enable
  placement_constraints = var.placement_constraints
  stack_name            = var.stack_name
  service_name          = "lldap"
  image                 = "lldap/lldap:latest"
  traefik               = { domain = var.domain, ssl = true, non-ssl = true, port = 17170 }
  networks              = concat([module.network], var.networks)
  converge_enable       = false
  ports = [
    { container = 3890, host = 389, publish_mode = var.publish_mode },
    { container = 6360, host = 636, publish_mode = var.publish_mode },
  ]
  environment_variables = {
    UID                  = 1000
    GID                  = 1000
    TZ                   = var.timezone
    LLDAP_JWT_SECRET     = nonsensitive(random_password.jwt_secret.result)
    LLDAP_KEY_SEED       = nonsensitive(random_password.key_seed.result)
    LLDAP_LDAP_BASE_DN   = var.base_dn
    LLDAP_LDAP_USER_PASS = local.admin_user_password

    # Database options
    LLDAP_DATABASE_URL = module.postgres.endpoint

    # SMTP options
    LLDAP_SMTP_OPTIONS__ENABLE_PASSWORD_RESET = var.smtp_enable ? var.enable_password_reset : false
    LLDAP_SMTP_OPTIONS__SERVER                = var.smtp_enable ? var.smtp_server : null
    LLDAP_SMTP_OPTIONS__PORT                  = var.smtp_enable ? var.smtp_port : null
    LLDAP_SMTP_OPTIONS__SMTP_ENCRYPTION       = var.smtp_enable ? var.smtp_encryption : null
    LLDAP_SMTP_OPTIONS__USER                  = var.smtp_enable ? var.smtp_user : null
    LLDAP_SMTP_OPTIONS__PASSWORD              = var.smtp_enable ? var.smtp_password : null
    LLDAP_SMTP_OPTIONS__FROM                  = var.smtp_enable ? var.smtp_from : null
  }
}
