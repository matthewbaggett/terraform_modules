module "tenants" {
  depends_on     = [aws_rds_cluster.cluster, aws_rds_cluster_instance.instance]
  for_each       = var.tenants
  source         = "./tenant"
  username       = each.value.username
  database       = each.value.database
  vpc_id         = data.aws_vpc.current.id
  cluster_id     = aws_rds_cluster.cluster.id
  engine         = aws_rds_cluster.cluster.engine
  admin_username = local.admin_username
  admin_password = local.admin_password
  tags = merge(
    try(var.application.application_tag, {}),
    {
      "TerraformRDSClusterName" = var.instance_name
      "TerraformRDSTenantName"  = each.value.username
    }
  )
}