module "tenants" {
  for_each       = var.tenants
  source         = "../tenant"
  debug_path     = local.debug_path
  username       = each.value.username
  database       = each.value.database
  engine         = var.engine
  admin_identity = module.admin_identity
  endpoint       = local.endpoints.write
}