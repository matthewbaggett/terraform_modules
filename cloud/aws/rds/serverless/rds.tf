resource "aws_rds_cluster" "cluster" {
  cluster_identifier                  = local.sanitised_name
  engine_mode                         = "provisioned"
  engine                              = data.aws_rds_engine_version.latest.engine
  engine_version                      = data.aws_rds_engine_version.latest.version
  database_name                       = module.admin_identity.username
  master_username                     = module.admin_identity.username
  master_password                     = module.admin_identity.password
  storage_encrypted                   = true
  enable_local_write_forwarding       = local.supports_local_write_forwarding
  backup_retention_period             = var.backup_retention_period_days
  skip_final_snapshot                 = var.skip_final_snapshot
  preferred_backup_window             = var.backup_window
  iam_database_authentication_enabled = true
  kms_key_id                          = aws_kms_key.db_key.arn
  apply_immediately                   = true
  db_subnet_group_name                = aws_db_subnet_group.sg.name
  vpc_security_group_ids              = [aws_security_group.rds.id]

  serverlessv2_scaling_configuration {
    max_capacity = local.scaling.max_capacity
    min_capacity = local.scaling.min_capacity
  }

  lifecycle {
    create_before_destroy = false
    precondition {
      error_message = "If you're using mysql 5.7, min_capacity must be greater or equal to 1, because it doesn't support auto-pause."
      condition     = local.is_mysql && var.engine_version == "5.7" ? local.scaling.min_capacity >= 1 : true
    }
  }

  tags = merge(
    try(var.application.application_tag, {}),
    {
      Name = var.instance_name
    }
  )
}
resource "aws_rds_cluster_instance" "instance" {
  cluster_identifier   = aws_rds_cluster.cluster.id
  identifier_prefix    = "${local.sanitised_name}-"
  instance_class       = "db.serverless"
  engine               = aws_rds_cluster.cluster.engine
  engine_version       = aws_rds_cluster.cluster.engine_version
  apply_immediately    = true
  publicly_accessible  = false
  db_subnet_group_name = aws_rds_cluster.cluster.db_subnet_group_name

  performance_insights_enabled          = var.enable_performance_insights
  performance_insights_retention_period = var.enable_performance_insights ? 7 : null
  performance_insights_kms_key_id       = var.enable_performance_insights ? aws_kms_key.db_key.arn : null

  lifecycle {
    create_before_destroy = false
  }

  tags = merge(
    try(var.application.application_tag, {}),
    {}
  )
}


