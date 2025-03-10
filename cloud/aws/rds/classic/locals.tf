locals {
  supported_engines  = ["mysql", "postgresql", "mariadb", ]
  ca_cert_identifier = aws_db_instance.instance.ca_cert_identifier
  debug_path         = "${path.root}/.debug/aws/rds/${var.instance_name}"
  endpoints = {
    write = {
      host = split(":", aws_db_instance.instance.endpoint)[0]
      port = split(":", aws_db_instance.instance.endpoint)[1]
    }
  }
}