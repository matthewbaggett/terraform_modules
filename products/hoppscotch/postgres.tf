module "postgres" {
  source                = "../../products/postgres"
  enable                = var.enable
  stack_name            = var.stack_name
  service_name          = "postgres"
  networks              = [module.network]
  database              = "hoppscotch"
  username              = "hoppscotch"
  placement_constraints = var.placement_constraints.persistent
  data_persist_path     = "${var.data_persist_path}/postgres"
  ports = [
    { container = 5432, host = 20050, publish_mode = var.publish_mode },
  ]
}