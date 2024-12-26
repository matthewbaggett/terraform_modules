locals {
  supported_mysql = ["5.7", "8.0"]
  supported_postgres = [
    "11.9", "11.21",
    "12.9", "12.11", "12.12", "12.13", "12.14", "12.15", "12.16", "12.17", "12.18", "12.19", "12.20", "12.22",
    "13.7", "13.8", "13.9", "13.10", "13.11", "13.12", "13.12", "13.13", "13.14", "13.15", "13.16", "13.18",
    "14.3", "14.4", "14.5", "14.6", "14.7", "14.8", "14.9", "14.10", "14.11", "14.12", "14.13", "14.15",
    "15.2", "15.3", "15.4", "15.5", "15.6", "15.7", "15.8", "15.10",
    "16.1", "16.2", "16.3", "16.4", "16.6",
  ]
  engines_supporting_local_write_forwarding = {
    "aurora-mysql" = ["8.0"]
    "aurora-postgresql" = [
      "14.13", "14.15",
      "15.8", "15.10",
      "16.4", "16.6",
    ]
  }
  # MB: This is a hack until I get my patch into terraform's aws provider: https://github.com/hashicorp/terraform-provider-aws/pull/40700
  supports_local_write_forwarding = (
    local.is_mysql && contains(local.engines_supporting_local_write_forwarding.aurora-mysql, local.engine_version) ||
    local.is_postgres && contains(local.engines_supporting_local_write_forwarding.aurora-postgresql, local.engine_version)
  )
  engine_version = (
    local.is_mysql
    ? (var.engine_version != null ? element(local.supported_mysql, length(local.supported_mysql) - 1) : false)
    : (local.is_postgres
      ? (var.engine_version != null ? element(local.supported_postgres, length(local.supported_postgres) - 1) : false)
      : false
    )
  )
}