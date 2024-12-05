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
  image                 = "traefik:v3.2"
  networks              = [module.traefik_network, module.docker_socket_proxy.network, ]
  remote_volumes        = { "/certs" = module.traefik_certs_volume.volume }
  placement_constraints = var.placement_constraints
  converge_enable       = false // @todo add healthcheck
  command = compact([
    "/usr/local/bin/traefik",
    "--api.insecure=true",
    "--api.dashboard=true",
    "--log.level=${var.log_level}",
    "--accesslog=${var.access_log ? "true" : "false"}",
    "--ping=true",

    # Confirm Docker Provider
    "--providers.docker=true",
    "--providers.docker.exposedbydefault=false",
    "--providers.docker.network=${module.traefik_network.name}",
    "--providers.docker.endpoint=http://${module.docker_socket_proxy.docker_service.name}:2375",

    # Confirm Swarm Provider
    "--providers.swarm=true",
    "--providers.swarm.exposedByDefault=false",
    "--providers.swarm.network=${module.traefik_network.name}",
    "--providers.swarm.endpoint=http://${module.docker_socket_proxy.docker_service.name}:2375",

    # Configure HTTP and redirect to HTTPS
    var.ssl_enable ? "--entrypoints.web.address=:80" : null,

    # Configure HTTPS
    var.ssl_enable ? "--entrypoints.websecure.address=:443" : null,
    var.ssl_enable && var.redirect_to_ssl ? "--entrypoints.web.http.redirections.entrypoint.to=websecure" : null,
    var.ssl_enable && var.redirect_to_ssl ? "--entrypoints.web.http.redirections.entrypoint.scheme=https" : null,

    # Configure the acme provider
    var.ssl_enable ? "--certificatesresolvers.default.acme.tlschallenge=true" : null,
    var.ssl_enable && var.acme_use_staging ? "--certificatesresolvers.default.acme.caserver=https://acme-staging-v02.api.letsencrypt.org/directory" : null,
    var.ssl_enable ? "--certificatesresolvers.default.acme.email=${var.acme_email}" : null,
    var.ssl_enable ? "--certificatesresolvers.default.acme.storage=/certs/acme.json" : null,
  ])
  traefik = var.traefik_service_domain != null ? {
    domain = var.traefik_service_domain
    port   = 8080
  } : null
  ports = [
    {
      host      = 80
      container = 80
    },
    {
      host      = 443
      container = 443
    },
    {
      host      = 8080
      container = 8080
    },
  ]

}
