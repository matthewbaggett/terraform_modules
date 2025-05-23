module "lldap" {
  // @todo: Write a healthcheck that uses a service account and calls ldapwhoami on the ssl port.
  source                = "../../docker/service"
  enable                = var.enable
  debug                 = var.debug
  debug_path            = var.debug_path
  placement_constraints = var.placement_constraints
  stack_name            = var.stack_name
  service_name          = "lldap"
  image                 = "${var.lldap_container_image}:${var.lldap_container_version}"
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
    UID             = 1000
    GID             = 1000
    TZ              = var.timezone
    LLDAP_VERBOSE   = var.verbose
    LLDAP_LDAP_PORT = 389
    #LLDAP_LDAPS_PORT     = 636
    LLDAP_HTTP_URL       = "https://${var.domain}"
    LLDAP_JWT_SECRET     = nonsensitive(random_password.jwt_secret.result)
    LLDAP_KEY_SEED       = nonsensitive(random_password.key_seed.result)
    LLDAP_KEY_FILE       = ""
    LLDAP_LDAP_BASE_DN   = var.base_dn
    LLDAP_LDAP_USER_DN   = var.admin_username # MB: Not actually a DN. Docs are bad. Expects a username.
    LLDAP_LDAP_USER_PASS = local.admin_password

    # LDAP over TLS options
    LLDAP_LDAPS_OPTIONS__ENABLED   = true
    LLDAP_LDAPS_OPTIONS__PORT      = 636
    LLDAP_LDAPS_OPTIONS__CERT_FILE = "/certs/cert.pem"
    LLDAP_LDAPS_OPTIONS__KEY_FILE  = "/certs/key.pem"

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
    # Don't put the certs in /data as the container tries to set permissions on them.
    "/certs/cert.pem" = tls_locally_signed_cert.lldap_cert.cert_pem
    "/certs/key.pem"  = tls_private_key.lldap_key.private_key_pem
    "/certs/ca.pem"   = tls_self_signed_cert.ca_cert.cert_pem
  }
  volumes = {
    "data" = "/data"
  }
}
