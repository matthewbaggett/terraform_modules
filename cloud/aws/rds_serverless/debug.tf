resource "local_file" "debug" {
  content = jsonencode({
    instance_name         = var.instance_name,
    tennants              = var.tennants,
    application_arn       = try(var.application.arn, null),
    application_name      = try(var.application.name, null),
    engine_user           = var.engine,
    engine_actual         = data.aws_rds_engine_version.latest.engine
    engine_version_actual = data.aws_rds_engine_version.latest.version,
  })
  filename        = "${path.root}/.debug/aws/rds/serverless/${var.instance_name}.json"
  file_permission = "0600"
}