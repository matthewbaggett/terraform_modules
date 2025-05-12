module "postgres" {
  source                = "../postgres"
  enable                = var.enable
  stack_name            = var.stack_name
  database              = "lldap"
  username              = "lldap"
  networks              = [module.network]
  data_persist_path     = var.postgres_data_persist_path
  placement_constraints = concat(var.placement_constraints, var.postgres_placement_constraints)
  ports                 = var.postgres_ports
}