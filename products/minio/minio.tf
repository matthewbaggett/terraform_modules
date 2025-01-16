module "minio" {
  source       = "../../docker/service"
  stack_name   = var.stack_name
  service_name = "minio"
  image        = "quay.io/minio/minio:latest"
  command      = ["minio", "server", "/data", ]
  environment_variables = {
    MINIO_ADDRESS              = "0.0.0.0:9000"
    MINIO_CONSOLE_ADDRESS      = "0.0.0.0:9001"
    MINIO_ROOT_USER            = random_pet.minio_admin_user.id
    MINIO_ROOT_PASSWORD        = random_password.minio_admin_password.result
    MINIO_SERVER_URL           = "https://${var.domain}"
    MINIO_BROWSER_REDIRECT_URL = "https://${var.domain}/ui/"
    #MINIO_BROWSER_REDIRECT     = true
    MINIO_API_ROOT_ACCESS = "on"
  }
  ports                 = var.ports
  mounts                = var.mounts
  networks              = concat(var.networks, [module.network])
  placement_constraints = var.placement_constraints
  labels = {
    "traefik.enable" = "true"

    // API redirect
    "traefik.http.routers.minio_api.rule"                      = "Host(`${var.domain}`) && !PathPrefix(`/ui`)"
    "traefik.http.routers.minio_api.service"                   = "minio_api"
    "traefik.http.routers.minio_api.entrypoints"               = try(var.traefik.ssl, false) ? "websecure" : "web"
    "traefik.http.routers.minio_api.tls.certresolver"          = try(var.traefik.ssl, false) ? "default" : null
    "traefik.http.services.minio_api.loadbalancer.server.port" = "9000"

    // UI redirect
    "traefik.http.routers.minio_ui.rule"                      = "Host(`${var.domain}`) && PathPrefix(`/ui`)"
    "traefik.http.routers.minio_ui.service"                   = "minio_ui"
    "traefik.http.routers.minio_ui.entrypoints"               = try(var.traefik.ssl, false) ? "websecure" : "web"
    "traefik.http.routers.minio_ui.tls.certresolver"          = try(var.traefik.ssl, false) ? "default" : null
    "traefik.http.services.minio_ui.loadbalancer.server.port" = "9001"

    // Create middleware to strip the prefix
    "traefik.http.middlewares.minio_ui.stripprefix.prefixes" = "/ui"

    # Attach the middleware to the UI router
    "traefik.http.routers.minio_ui.middlewares" = "minio_ui"
  }
}

