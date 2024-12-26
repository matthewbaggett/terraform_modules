resource "local_file" "debug" {
  content = nonsensitive(jsonencode({
    rds = {
      instance_name    = var.instance_name,
      tennants         = var.tenants,
      application_arn  = try(var.application.arn, null),
      application_name = try(var.application.name, null),
      engine = {
        requested = {
          engine  = var.engine,
          version = var.engine_version
        }
        resolved = {
          engine  = data.aws_rds_engine_version.latest[var.engine_version].engine,
          version = data.aws_rds_engine_version.latest[var.engine_version].version,
          match   = data.aws_rds_engine_version.latest,
        }
      }
      #endpoints = {
      #  write = aws_rds_cluster_endpoint.endpoint["write"].endpoint,
      #  read  = aws_rds_cluster_endpoint.endpoint["read"].endpoint
      #}
      admin = {
        username = local.admin_username
        password = local.admin_password
      }
    }
    tenants = var.tenants
  }))
  filename        = "${path.root}/.debug/aws/rds/serverless/${var.instance_name}.provided.json"
  file_permission = "0600"
}
resource "local_file" "debug_result" {
  content = nonsensitive(jsonencode({
    rds = {
      instance_name    = var.instance_name,
      tennants         = var.tenants,
      application_arn  = try(var.application.arn, null),
      application_name = try(var.application.name, null),
      engine = {
        requested = {
          engine  = var.engine,
          version = var.engine_version
        }
        resolved = {
          engine  = data.aws_rds_engine_version.latest[var.engine_version].engine,
          version = data.aws_rds_engine_version.latest[var.engine_version].version,
          match   = data.aws_rds_engine_version.latest[var.engine_version],
        }
      }
      endpoints = {
        write = aws_rds_cluster_endpoint.endpoint["write"].endpoint,
        read  = aws_rds_cluster_endpoint.endpoint["read"].endpoint
      }
    }
    tenants = merge({ admin = {
      username = local.admin_username
      password = local.admin_password
    } }, local.output_tenants)

  }))
  filename        = "${path.root}/.debug/aws/rds/serverless/${var.instance_name}.result.json"
  file_permission = "0600"
}