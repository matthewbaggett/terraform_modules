module "metube" {
  source       = "../../docker/service"
  image        = "ghcr.io/alexta69/metube"
  enable       = var.enabled
  service_name = "metube"
  stack_name   = var.stack_name
  environment_variables = {
    DOWNLOAD_DIR = "/media/youtube"
    HTTPS        = false
    CUSTOM_DIRS  = true
    TEMP_DIR     = "/media/youtube/.temp"
  }
  remote_volumes = {
    "/media" = module.media
  }
  mounts = {
    "/etc/localtime" = "/etc/localtime"
  }
  networks        = [module.network]
  converge_enable = false
  traefik = {
    domain = "metube.${var.traefik.domain}"
    ssl    = true
    port   = 8081
  }
  placement_constraints = var.placement_constraints
}