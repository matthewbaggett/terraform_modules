module "nginx_proxy_manager" {
  source          = "../../docker/service"
  enable          = var.enable
  image           = "jc21/nginx-proxy-manager:latest"
  service_name    = "nginx"
  stack_name      = "proxy"
  networks        = [module.network]
  converge_enable = false # @todo: Write a healthcheck for the service and enable this.
  ports = [
    { host = 80, container = 80, publish_mode = var.publish_mode },
    { host = 443, container = 443, publish_mode = var.publish_mode },
    { host = 8080, container = 81, publish_mode = var.publish_mode },
  ]
  mounts = {
    "${var.data_persist_path}/data"        = "/data",
    "${var.data_persist_path}/letsencrypt" = "/etc/letsencrypt",
  }
  environment_variables = {
    DB_POSTGRES_HOST       = module.postgres.service_name
    DB_POSTGRES_PORT       = "5432"
    DB_POSTGRES_USER       = module.postgres.username
    DB_POSTGRES_NAME       = module.postgres.database
    DB_POSTGRES_PASSWORD   = module.postgres.password
    DISABLE_IPV6           = "true"
    INITIAL_ADMIN_EMAIL    = var.admin_email
    INITIAL_ADMIN_PASSWORD = var.admin_password
  }
}
