module "postgres" {
  source                = "../../../products/postgres"
  stack_name            = var.stack_name
  placement_constraints = var.placement_constraints
  postgres_version      = "15"
  networks              = [module.forgejo_network]
  data_persist_path     = "/fast/gitea/db"
  ports = [
    {
      host      = 62800
      container = 5432
    },
  ]
}