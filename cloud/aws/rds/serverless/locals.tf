locals {
  supported_engines = {
    mysql    = ["mysql", "aurora-mysql", ]
    mariadb  = ["mariadb", ]
    postgres = ["postgresql", "aurora-postgresql", ]
  }
  supported_engines_list = flatten([for k, v in local.supported_engines : v])
  ca_cert_identifier     = aws_rds_cluster_instance.instance.ca_cert_identifier
  debug_path             = "${path.root}/.debug/aws/rds/serverless/${var.instance_name}"
  endpoints = {
    write = {
      # Host should be the same as the cluster endpoint, sans the port
      host = aws_rds_cluster_endpoint.endpoint["write"].endpoint
      port = local.port
    }
    read = {
      host = aws_rds_cluster_endpoint.endpoint["read"].endpoint
      port = local.port
    }
  }
}