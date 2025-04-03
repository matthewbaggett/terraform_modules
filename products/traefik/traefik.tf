module "traefik_certs_volume" {
  source      = "../../docker/volume"
  stack_name  = var.stack_name
  volume_name = "traefik_certs"
}
locals {
  command = distinct(compact(concat(
    [
      "/usr/local/bin/traefik",
    ],

    # API settings
    [
      "--api.insecure=${var.api_insecure || var.enable_dashboard ? "true" : "false"}", # @todo MB: Revisit this and swap to using traefik-ception routing
      "--api.dashboard=${var.enable_dashboard ? "true" : "false"}",
      "--api.debug=${var.api_debug ? "true" : "false"}",
    ],

    # Global settings
    [
      "--global.checknewversion=false", # We're in a container so this really isn't something we care about
      "--global.sendanonymoususage=${var.enable_stats_collection ? "true" : "false"}",
    ],

    # Logging settings
    [
      "--log.level=${var.log_level}",
      "--accesslog=${var.access_log ? "true" : "false"}",
      "--accesslog.format=${var.access_log_format}",
      "--accesslog.fields.defaultmode=${var.access_log_fields_default_mode}",
    ],

    # Ping settings
    var.enable_ping ? [
      "--ping=true",
      "--ping.entrypoint=${var.ping_entrypoint}",
    ] : [],

    # Docker Provider
    var.enable_docker_provider ? [
      "--providers.docker=true",
      "--providers.docker.exposedByDefault=false",
      "--providers.docker.network=${module.network.name}",
      "--providers.docker.endpoint=http://${module.docker_socket_proxy.docker_service.name}:2375",
      ] : [
      "--providers.docker=false"
    ],

    # Swarm Provider
    var.enable_swarm_provider ? [
      "--providers.swarm=true",
      "--providers.swarm.exposedByDefault=false",
      "--providers.swarm.network=${module.network.name}",
      "--providers.swarm.endpoint=http://${module.docker_socket_proxy.docker_service.name}:2375",
      ] : [
      "--providers.swarm=false"
    ],

    # Configure HTTP
    var.http_port != null || var.redirect_to_ssl ? [
      "--entrypoints.web.address=:${var.http_port}",
      "--entrypoints.web.reusePort=${var.enable_port_reuse ? "true" : "false"}",
    ] : [],

    # Configure HTTPS
    var.https_port != null && var.enable_ssl ? [
      "--entrypoints.websecure.address=:${var.https_port}",
      "--entrypoints.websecure.reusePort=${var.enable_port_reuse ? "true" : "false"}",
    ] : [],

    # Configure redirecting HTTP to HTTPS
    var.redirect_to_ssl ? [
      "--entrypoints.web.http.redirections.entrypoint.to=websecure",
      "--entrypoints.web.http.redirections.entrypoint.scheme=https",
    ] : [],

    # Configure the acme provider if SSL is enabled
    var.enable_ssl ? [
      "--certificatesresolvers.default.acme.tlschallenge=true",
      (var.acme_use_staging ? "--certificatesresolvers.default.acme.caserver=https://acme-staging-v02.api.letsencrypt.org/directory" : null),
      "--certificatesresolvers.default.acme.email=${var.acme_email}",
      "--certificatesresolvers.default.acme.storage=/certs/acme.json",
    ] : [],

    # Configure UDP
    var.enable_udp ? flatten([for name, ports in var.udp_entrypoints : [for port in ports : "--entrypoints.${name}.address=:${port}/udp"]]) : []
  )))
}
module "traefik" {
  source                = "../../docker/service"
  depends_on            = [module.docker_socket_proxy, module.network, ]
  stack_name            = var.stack_name
  service_name          = "traefik"
  image                 = var.traefik_image
  networks              = [module.network, module.docker_socket_proxy.network, ]
  remote_volumes        = { "/certs" = module.traefik_certs_volume.volume }
  placement_constraints = var.placement_constraints
  global                = true
  healthcheck           = ["CMD", "wget", "--no-verbose", "--tries", 1, "--spider", "http://localhost:8080"]
  converge_enable       = true
  command               = local.command

  traefik = var.traefik_dashboard_service_domain != null ? {
    domain           = var.traefik_dashboard_service_domain
    port             = var.dashboard_port
    ssl              = var.enable_ssl
    non-ssl          = var.enable_non_ssl
    basic-auth-users = var.traefik_dashboard_service_enable_basic_auth ? ["traefik"] : []
  } : null
  ports = [
    {
      host      = var.http_port
      container = var.http_port
      }, {
      host      = var.https_port
      container = var.https_port
      }, {
      host      = var.dashboard_port
      container = var.dashboard_port
    },
  ]
}
