locals {
  supported_engines  = ["aurora-mysql", "aurora-postgresql", ]
  ca_cert_identifier = aws_rds_cluster_instance.instance.ca_cert_identifier
  debug_path         = "${path.root}/.debug/aws/rds/serverless/${var.instance_name}"
  endpoints = {
    write = {
      # Host should be the same as the cluster endpoint, sans the port
      host = split(":", aws_rds_cluster_endpoint.endpoint["write"].endpoint)[0]
      port = split(":", aws_rds_cluster_endpoint.endpoint["write"].endpoint)[1]
    }
    read = {
      host = split(":", aws_rds_cluster_endpoint.endpoint["read"].endpoint)[0]
      port = split(":", aws_rds_cluster_endpoint.endpoint["read"].endpoint)[1]
    }
  }
}