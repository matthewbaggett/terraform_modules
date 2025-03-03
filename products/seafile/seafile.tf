variable "domain" {
  type        = string
  description = "The domain to use for the traefik configuration."
}
module "seafile" {
  depends_on            = [module.memcached, module.mysql, module.network]
  source                = "../../docker/service"
  enable                = var.enable
  stack_name            = var.stack_name
  image                 = "h44z/seafile-ce:${var.seafile_version}"
  placement_constraints = var.placement_constraints
  service_name          = var.service_name
  networks              = concat([module.network.network], var.networks, )
  mounts = {
    "${var.data_persist_path}/seafile" = "/seafile"
    "${var.data_persist_path}/logs"    = "/opt/seafile/logs"
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
    MYSQL_SERVER        = module.mysql.service_name
    MYSQL_USER          = module.mysql.username
    MYSQL_USER_PASSWORD = module.mysql.password
    MYSQL_PORT          = 3306

    # General Seafile Settings
    SEAFILE_VERSION  = var.seafile_version
    SEAFILE_NAME     = "Seafile"
    SEAFILE_ADDRESS  = var.domain
    SEAFILE_ADMIN    = "admin@${var.domain}"
    SEAFILE_ADMIN_PW = "changeme"

    # OnlyOffice Settings
    ONLYOFFICE_JWT_SECRET = "Supers3cr3t" // @todo generate a key instead

    # Optional Seafile Settings
    LDAP_IGNORE_CERT_CHECK = true

    # Traefik (Reverse Proxy) Settings
    DOMAINNAME = var.domain

    # All other settings can be edited in the conf dir (/seafile/conf) once the container started up!

    # runmode, default = run
    #MODE=maintenance
  }
  converge_enable = false // @todo: Fix healthcheck and change this.
}

