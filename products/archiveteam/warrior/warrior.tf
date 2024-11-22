module "warrior" {
  source                = "../../../docker/service"
  image                 = "atdr.meo.ws/archiveteam/warrior-dockerfile"
  stack_name            = "archiveteam"
  service_name          = var.service_name
  placement_constraints = var.placement_constraints
  ports = [
    {
      host      = var.port
      container = 8001
    }
  ]
  labels = {
    "com.centurylinklabs.watchtower.enable" = "true"
  }
  environment_variables = {
    "DOWNLOADER"           = "greyscale"
    "HTTP_PASSWORD"        = local.http_password
    "HTTP_USERNAME"        = var.http_username
    "SELECTED_PROJECT"     = var.selected_project
    "CONCURRENT_ITEMS"     = var.concurrency
    "SHARED_RSYNC_THREADS" = var.shared_rsync_threads
  }
  parallelism = var.warrior_instances
}

