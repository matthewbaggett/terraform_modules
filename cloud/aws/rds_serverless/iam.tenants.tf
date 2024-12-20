module "tenants" {
  depends_on               = [aws_rds_cluster.cluster, aws_rds_cluster_instance.instance]
  for_each                 = var.tenants
  source                   = "./tenant"
  username                 = each.value.username
  database                 = each.value.database
  app_name                 = local.app_name
  vpc_id                   = data.aws_vpc.current.id
  aws_profile              = var.aws_profile
  cluster_id               = aws_rds_cluster.cluster.id
  super_user_iam_role_name = aws_iam_role.rds_instance_policy.name
  engine                   = aws_rds_cluster.cluster.engine
  admin_username           = local.admin.username
  admin_password           = local.admin.password
  tags = merge(
    try(var.application.application_tag, {}),
    {
      "TerraformRDSClusterName" = var.instance_name
      "TerraformRDSTenantName"  = each.value.username
    }
  )
}