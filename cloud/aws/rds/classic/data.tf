data "aws_rds_engine_version" "latest" {
  engine = var.engine
  latest = true

  filter {
    name   = "engine-mode"
    values = ["provisioned"]
  }

  dynamic "filter" {
    # MB: We're doing this instead of using the engine_version directly to avoid passing an empty string to the AWS API
    for_each = var.engine_version != null ? [var.engine_version] : []
    content {
      name   = "engine-version"
      values = [var.engine_version]
    }
  }
}