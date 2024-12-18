resource "local_file" "debug" {
  content = jsonencode({
    rds = {
      instance_name         = var.instance_name,
      tennants              = var.tenants,
      application_arn       = try(var.application.arn, null),
      application_name      = try(var.application.name, null),
      engine_user           = var.engine,
      engine_actual         = data.aws_rds_engine_version.latest.engine
      engine_version_actual = data.aws_rds_engine_version.latest.version,
    }
    tenants = {
      input  = var.tenants
      output = local.output_tenants
    }
  })
  filename        = "${path.root}/.debug/aws/rds/serverless/${var.instance_name}.json"
  file_permission = "0600"
}