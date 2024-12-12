resource "aws_rds_cluster" "cluster" {
  cluster_identifier          = var.instance_name
  engine                      = var.engine
  engine_mode                 = "provisioned"
  engine_version              = var.engine_version
  database_name               = var.admin_user.username
  master_username             = var.admin_user.username
  manage_master_user_password = true
  storage_encrypted           = true

  serverlessv2_scaling_configuration {
    max_capacity             = var.scaling.max_capacity
    min_capacity             = var.scaling.min_capacity
    seconds_until_auto_pause = var.scaling.seconds_until_auto_pause
  }
  tags = merge(
    var.application.application_tag,
    {}
  )
}
