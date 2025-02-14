module "postgres" {
  source                = "../../../products/postgres"
  stack_name            = var.stack_name
  placement_constraints = var.placement_constraints
  networks              = [module.network]
  data_persist_path     = var.database_storage_path
  ports = [
    {
      host      = 62800
      container = 5432
    },
  ]
}