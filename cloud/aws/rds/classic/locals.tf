locals {
  supported_engines = {
    mysql    = ["mysql", ]
    mariadb  = ["mariadb", ]
    postgres = ["postgresql", ]
  }
  supported_engines_list = flatten([for k, v in local.supported_engines : v])
  ca_cert_identifier     = aws_db_instance.instance.ca_cert_identifier
  debug_path             = "${path.root}/.debug/aws/rds/${var.instance_name}"
  endpoints = {
    write = {
      host = split(":", aws_db_instance.instance.endpoint)[0]
      port = split(":", aws_db_instance.instance.endpoint)[1]
    }
  }
}