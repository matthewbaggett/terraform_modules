resource "aws_iam_user" "tenants" {
  for_each = var.tenants
  name     = join("-", [var.instance_name, each.value.username])
  tags = merge(
    try(var.application.application_tag, {}),
    {}
  )
}
resource "aws_iam_access_key" "tenants" {
  for_each = var.tenants
  user     = aws_iam_user.tenants[each.key].name
  status   = each.value.active ? "Active" : "Inactive"
}
resource "aws_iam_group_membership" "tenants" {
  for_each = var.tenants
  group    = aws_iam_group.user_access[each.key].name
  name     = join("-", ["RDS", var.instance_name, "ReadWrite"])
  users    = [for tenant in aws_iam_user.tenants : tenant.name]
}

locals {
  output_tenants = {
    for tenant in var.tenants : tenant.username => {
      username   = tenant.username,
      database   = tenant.database,
      access_key = aws_iam_access_key.tenants[tenant.username].id,
      secret_key = aws_iam_access_key.tenants[tenant.username].secret
    }
  }
}
output "tenants" {
  value = local.output_tenants
  precondition {
    condition     = length(aws_iam_user.tenants) > 0
    error_message = "No tenants found"
  }
}