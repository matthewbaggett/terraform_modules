module "secrets" {
  for_each   = var.secrets
  source     = "../../docker/secret"
  stack_name = var.stack_name
  name       = each.key
  value      = each.value
  debug_path = "${local.debug_path}/secrets"
}