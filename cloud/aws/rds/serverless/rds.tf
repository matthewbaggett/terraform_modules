data "aws_rds_engine_version" "latest" {
  for_each = toset([var.engine_version])
  engine   = var.engine
  version  = local.engine_version
  latest   = true
  filter {
    name   = "engine-mode"
    values = ["provisioned"]
  }
}
resource "aws_kms_key" "db_key" {
  description = "RDS ${var.instance_name} Encryption Key"
  tags = merge(
    try(var.application.application_tag, {}),
    {
      TerraformSecretType = "RDSMasterEncryptionKey"
    }
  )
}
resource "aws_rds_cluster" "cluster" {
  cluster_identifier                  = local.sanitised_name
  engine_mode                         = "provisioned"
  engine                              = data.aws_rds_engine_version.latest[var.engine_version].engine
  engine_version                      = data.aws_rds_engine_version.latest[var.engine_version].version
  database_name                       = local.admin_username
  master_username                     = local.admin_username
  master_password                     = local.admin_password
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

resource "aws_rds_cluster_endpoint" "endpoint" {
  depends_on                  = [aws_rds_cluster_instance.instance]
  for_each                    = { "write" = "ANY", "read" = "READER" }
  cluster_endpoint_identifier = join("-", [local.sanitised_name, each.key, "endpoint"])
  cluster_identifier          = aws_rds_cluster.cluster.id
  custom_endpoint_type        = each.value

  tags = merge(
    try(var.application.application_tag, {}),
    {}
  )
}


output "endpoints" {
  value = aws_rds_cluster_endpoint.endpoint
}