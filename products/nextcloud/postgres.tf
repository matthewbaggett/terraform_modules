module "postgres" {
  source                = "../postgres"
  enable                = var.enable
  stack_name            = var.stack_name
  database              = "nextcloud"
  username              = "nextcloud"
  networks              = [module.network]
  data_persist_path     = "/goliath/nextcloud/postgres"
  placement_constraints = var.placement_constraints
  ports                 = var.postgres_ports
}