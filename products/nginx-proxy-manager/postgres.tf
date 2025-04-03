module "postgres" {
  source            = "../../products/postgres"
  enable            = var.enable
  stack_name        = "proxy"
  service_name      = "postgres"
  networks          = [module.network]
  database          = "nginx-proxy-manager"
  username          = "nginx-proxy-manager"
  data_persist_path = "${var.data_persist_path}/postgres"
  ports = [
    { container = 5432, publish_mode = var.publish_mode },
  ]
}