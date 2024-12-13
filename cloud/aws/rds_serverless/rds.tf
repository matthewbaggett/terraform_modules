data "aws_rds_engine_version" "latest" {
  engine = var.engine
  latest = true
  filter {
    name   = "engine-mode"
    values = ["provisioned"]
  }
}
resource "aws_rds_cluster" "cluster" {
  cluster_identifier_prefix     = "${var.instance_name}-"
  engine_mode                   = "provisioned"
  engine                        = data.aws_rds_engine_version.latest.engine
  engine_version                = data.aws_rds_engine_version.latest.version
  database_name                 = local.admin_username
  master_username               = local.admin_username
  manage_master_user_password   = true
  storage_encrypted             = true
  enable_local_write_forwarding = true
  backup_retention_period       = var.backup_retention_period_days
  skip_final_snapshot           = var.skip_final_snapshot
  preferred_backup_window       = var.backup_window

  serverlessv2_scaling_configuration {
    max_capacity = var.scaling.max_capacity
    min_capacity = var.scaling.min_capacity
  }
  tags = merge(
    try(var.application.application_tag, {}),
    {}
  )
}

resource "aws_rds_cluster_instance" "instance" {
  cluster_identifier  = aws_rds_cluster.cluster.id
  instance_class      = "db.serverless"
  engine              = aws_rds_cluster.cluster.engine
  engine_version      = aws_rds_cluster.cluster.engine_version
  apply_immediately   = true
  publicly_accessible = false
  tags = merge(
    try(var.application.application_tag, {}),
    {}
  )
}