module "postgres" {
  source     = "../../products/postgres"
  stack_name = var.stack_name
  database   = "dex"
  networks   = [module.network]
}