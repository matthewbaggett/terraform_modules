module "config" {
  for_each   = var.configs
  source     = "../../docker/config"
  stack_name = var.stack_name
  name       = each.key
  value      = each.value
}