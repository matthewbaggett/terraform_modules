variable "database_url_string" {
  description = "Postgres or MySQL connection string. Leaving this null will provision an ephemeral postgres server."
  type        = string
  default     = null
}
locals {
  database_url_string          = var.database_url_string == null ? module.postgres[0].endpoint : var.database_url_string
  provision_ephemeral_postgres = var.database_url_string == null
}
module "postgres" {
  count                 = local.provision_ephemeral_postgres ? 1 : 0
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