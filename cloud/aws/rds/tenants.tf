/*module "tenants" {
  depends_on     = [aws_db_instance.instance]
  for_each       = var.tenants
  source         = "./tenant"
  username       = each.value.username
  database       = each.value.database
  vpc_id         = data.aws_vpc.current.id
  cluster_id     = aws_rds_cluster.cluster.id
  engine         = data.aws_rds_engine_version.latest.engine
  admin_username = module.admin_identity.username
  admin_password = module.admin_identity.password
}*/