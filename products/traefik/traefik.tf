module "traefik_certs_volume" {
  source      = "../../docker/volume"
  stack_name  = var.stack_name
  volume_name = "traefik_certs"
}
module "traefik" {
  source                = "../../docker/service"
  depends_on            = [module.docker_socket_proxy]
  stack_name            = var.stack_name
  service_name          = "traefik"
  image                 = var.traefik_image
  networks              = [module.traefik_network, module.docker_socket_proxy.network, ]
  remote_volumes        = { "/certs" = module.traefik_certs_volume.volume }
  placement_constraints = var.placement_constraints
  converge_enable       = false // @todo add healthcheck
  command = distinct(compact([
    "/usr/local/bin/traefik",
    "--api.insecure=${var.api_insecure ? "true" : "false"}", # @todo MB: Revisit this and swap to using traefik-ception routing
    "--api.dashboard=${var.enable_dashboard ? "true" : "false"}",
    "--api.debug=${var.api_debug ? "true" : "false"}",

    # Global settings
    "--global.checknewversion=false", # We're in a container so this really isn't something we care about
    "--global.sendanonymoususage=${var.enable_stats_collection ? "true" : "false"}",

    # Logging settings
    "--log.level=${var.log_level}",
    "--accesslog=${var.access_log ? "true" : "false"}",
    "--accesslog.format=${var.access_log_format}",
    "--accesslog.fields.defaultmode=${var.access_log_fields_default_mode}",

    # Ping settings
    (var.enable_ping ? "--ping=true" : null),
    (var.enable_ping ? "--ping.entrypoint=${var.ping_entrypoint}" : null),

    # Docker Provider
    "--providers.docker=${var.enable_docker_provider ? "true" : "false"}",
    "--providers.docker.exposedByDefault=false",
    "--providers.docker.network=${module.traefik_network.name}",
    "--providers.docker.endpoint=http://${module.docker_socket_proxy.docker_service.name}:2375",

    # Swarm Provider
    "--providers.swarm=${var.enable_swarm_provider ? "true" : "false"}",
    "--providers.swarm.exposedByDefault=false",
    "--providers.swarm.network=${module.traefik_network.name}",
    "--providers.swarm.endpoint=http://${module.docker_socket_proxy.docker_service.name}:2375",

    # Configure HTTP
    (var.http_port != null ? "--entrypoints.web.address=:${var.http_port}" : null),

    # Configure HTTPS
    (var.https_port != null && var.enable_ssl ? "--entrypoints.websecure.address=:${var.https_port}" : null),
    (var.https_port != null && var.enable_ssl && var.redirect_to_ssl ? "--entrypoints.web.address=:${var.http_port}" : null),
    (var.https_port != null && var.enable_ssl && var.redirect_to_ssl ? "--entrypoints.web.http.redirections.entrypoint.to=websecure" : null),
    (var.https_port != null && var.enable_ssl && var.redirect_to_ssl ? "--entrypoints.web.http.redirections.entrypoint.scheme=https" : null),

    # Configure the acme provider
    (var.enable_ssl ? "--certificatesresolvers.default.acme.tlschallenge=true" : null),
    (var.enable_ssl && var.acme_use_staging ? "--certificatesresolvers.default.acme.caserver=https://acme-staging-v02.api.letsencrypt.org/directory" : null),
    (var.enable_ssl ? "--certificatesresolvers.default.acme.email=${var.acme_email}" : null),
    (var.enable_ssl ? "--certificatesresolvers.default.acme.storage=/certs/acme.json" : null),
  ]))
  traefik = var.traefik_service_domain != null ? {
    domain  = var.traefik_service_domain
    port    = var.dashboard_port
    ssl     = var.enable_ssl
    non-ssl = var.enable_non_ssl
  } : null
  ports = [
    {
      host      = var.http_port
      container = var.http_port
    },
    {
      host      = var.https_port
      container = var.https_port
    },
    {
      host      = var.dashboard_port
      container = var.dashboard_port
    },
  ]
}
