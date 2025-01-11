variable "allocated_storage_gb" {
  type        = number
  default     = 5
  description = "The storage size for the RDS instance, measured in GB."
}
variable "max_allocated_storage_gb" {
  type        = number
  default     = 100
  description = "The maximum storage size for the RDS instance, measured in GB."
}
resource "aws_db_instance" "instance" {
  identifier_prefix       = "${local.sanitised_name}-"
  instance_class          = var.instance_class
  engine                  = data.aws_rds_engine_version.latest.engine
  engine_version          = data.aws_rds_engine_version.latest.version
  storage_encrypted       = true
  kms_key_id              = aws_kms_key.db_key.arn
  publicly_accessible     = false
  apply_immediately       = true
  db_subnet_group_name    = aws_db_subnet_group.sg.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  skip_final_snapshot     = var.skip_final_snapshot
  username                = module.admin_identity.username
  password                = module.admin_identity.password
  backup_window           = var.backup_window
  backup_retention_period = var.backup_retention_period_days
  allocated_storage       = var.allocated_storage_gb
  max_allocated_storage   = var.max_allocated_storage_gb

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
  copy_tags_to_snapshot = true
}
