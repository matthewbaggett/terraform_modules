variable "admin_email" {
  type        = string
  description = "The email address of the admin user."
}
variable "admin_password" {
  default     = null
  description = "Optional password for the admin user. If not provided, a random password will be generated."
}
resource "random_password" "admin_password" {
  count   = var.admin_password == null ? 1 : 0
  length  = 32
  special = false
}
locals {
  admin_password = var.admin_password != null ? var.admin_password : random_password.admin_password[0].result
}
variable "protocol" {
  default     = "https"
  description = "http or https"
  type        = string
}
module "seafile" {
  depends_on            = [module.memcached, module.mysql, module.network]
  source                = "../../docker/service"
  enable                = var.enable
  stack_name            = var.stack_name
  image                 = "seafileltd/seafile-mc:${var.seafile_version}"
  placement_constraints = var.placement_constraints
  service_name          = var.service_name
  networks              = concat([module.network.network], var.networks, )
  ports                 = var.ports
  mounts = {
    "${var.data_persist_path}/data" = "/seafile"
    "${var.data_persist_path}/logs" = "/opt/seafile/logs"
  }
  labels = {
    "traefik.enable"         = "true"
    "traefik.docker.network" = "proxy-net"
    # HTTP Router Seafile/Seahub
    "traefik.http.routers.seafile.rule"                      = "(Host(`seafile.${var.domain}`))"
    "traefik.http.routers.seafile.entrypoints"               = "websecure"
    "traefik.http.routers.seafile.tls"                       = "true"
    "traefik.http.routers.seafile.tls.certresolver"          = "letsencryptresolver"
    "traefik.http.routers.seafile.service"                   = "seafile"
    "traefik.http.routers.seafile.middlewares"               = "sec-headers"
    "traefik.http.services.seafile.loadbalancer.server.port" = "8000"
    # HTTP Router Seafdav
    "traefik.http.routers.seafile-dav.rule"                      = "Host(`seafile.${var.domain}`) && PathPrefix(`/seafdav`)"
    "traefik.http.routers.seafile-dav.entrypoints"               = "websecure"
    "traefik.http.routers.seafile-dav.tls"                       = "true"
    "traefik.http.routers.seafile-dav.tls.certresolver"          = "letsencryptresolver"
    "traefik.http.routers.seafile-dav.service"                   = "seafile-dav"
    "traefik.http.services.seafile-dav.loadbalancer.server.port" = "8080"
    # HTTP Router Seafhttp
    "traefik.http.routers.seafile-http.rule"                      = "Host(`seafile.${var.domain}`) && PathPrefix(`/seafhttp`)"
    "traefik.http.routers.seafile-http.entrypoints"               = "websecure"
    "traefik.http.routers.seafile-http.tls"                       = "true"
    "traefik.http.routers.seafile-http.tls.certresolver"          = "letsencryptresolver"
    "traefik.http.routers.seafile-http.middlewares"               = "seafile-strip"
    "traefik.http.routers.seafile-http.service"                   = "seafile-http"
    "traefik.http.services.seafile-http.loadbalancer.server.port" = "8082"
    # Middlewares 
    "traefik.http.middlewares.seafile-strip.stripprefix.prefixes"       = "/seafhttp"
    "traefik.http.middlewares.sec-headers.headers.sslredirect"          = "true"
    "traefik.http.middlewares.sec-headers.headers.browserXssFilter"     = "true"
    "traefik.http.middlewares.sec-headers.headers.contentTypeNosniff"   = "true"
    "traefik.http.middlewares.sec-headers.headers.forceSTSHeader"       = "true"
    "traefik.http.middlewares.sec-headers.headers.stsIncludeSubdomains" = "true"
    "traefik.http.middlewares.sec-headers.headers.stsPreload"           = "true"
    "traefik.http.middlewares.sec-headers.headers.referrerPolicy"       = "same-origin"
  }
  environment_variables = {
    # Base settings
    TIME_ZONE = "Europe/Amsterdam"

    # Database settings, remove this section to use a sqlite database.
    # You can either specify a root password (MYSQL_ROOT_PASSWORD), or use your exsting database tables.
    # Also specifying MYSQL_USER_HOST only makes sense if MYSQL_ROOT_PASSWORD is given, otherwise no new MySQL user will be created.
    # To use an external database, simply remove the MySQL service from the docker-compose.yml.
    DB_HOST          = module.mysql.service_name
    DB_PORT          = 3306
    DB_USER          = module.mysql.username
    DB_PASSWORD      = module.mysql.password
    DB_ROOT_PASSWORD = module.mysql.root_password

    INIT_SEAFILE_ADMIN_EMAIL    = var.admin_email
    INIT_SEAFILE_ADMIN_PASSWORD = local.admin_password

    # General Seafile Settings
    SEAFILE_SERVER_HOSTNAME = var.domain
    SEAFILE_SERVER_PROTOCOL = var.protocol
    SEAFILE_LOG_TO_STDOUT   = true
    ENABLE_SEADOC           = false
    SEADOC_SERVER_URL       = "${var.protocol}://${var.domain}/seadoc"
    JWT_PRIVATE_KEY         = "Supers3cr3t" // @todo generate a key instead
  }
  converge_enable = false // @todo: Fix healthcheck and change this.
}

