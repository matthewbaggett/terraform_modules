variable "endpoint" {
  type = object({
    host = string
    port = number
  })
  description = "The endpoint of the RDS cluster or instance"
  validation {
    error_message = "Host isn't supposed to contain a port!"
    condition     = can(regex("^[^:]+$", var.endpoint.host))
  }
}
locals {
  db_tunnel_remote = {
    host = var.endpoint.host
    port = local.is_mysql ? 3306 : (local.is_postgres ? 5432 : null)
  }
  mysql_command    = try("${var.mysql_binary} --ssl-verify-server-cert=false -h ${data.ssh_tunnel.db.local.host} -P ${data.ssh_tunnel.db.local.port} -u ${var.admin_identity.username}", "")
  postgres_command = try("${var.postgres_binary} -h ${data.ssh_tunnel.db.local.host} -p ${data.ssh_tunnel.db.local.port} -U ${var.admin_identity.username} -d ${var.admin_identity.username}", "")
  database_environment_variables = {
    PGPASSWORD = !local.is_mysql ? nonsensitive(var.admin_identity.password) : null,
    MYSQL_PWD  = local.is_mysql ? nonsensitive(var.admin_identity.password) : null,
  }
}
resource "local_file" "debug" {
  filename = "${local.debug_path}/${local.username}.json"
  content = jsonencode({
    db_tunnel_remote = local.db_tunnel_remote,
    #mysql_command                  = local.mysql_command,
    #postgres_command               = local.postgres_command,
    database_environment_variables = local.database_environment_variables,
  })
  file_permission = "0600"
}
data "ssh_tunnel" "db" {
  connection_name = "db-${var.engine}"
  remote          = local.db_tunnel_remote
}
resource "terraform_data" "db" {
  connection {
    host = data.ssh_tunnel.db.remote.host
    port = data.ssh_tunnel.db.remote.port
  }
  provisioner "local-exec" {
    command = "echo 'Connecting to ${local.db_tunnel_remote.host}:${local.db_tunnel_remote.port} as ${var.admin_identity.username} via ${data.ssh_tunnel.db.connection_name}'"
  }
  provisioner "local-exec" {
    command = (local.is_mysql
      ? "echo 'CREATE DATABASE IF NOT EXISTS ${var.database}' | ${local.mysql_command}"
      : "echo 'CREATE DATABASE ${var.database}' | ${local.postgres_command}"
    )
    environment = local.database_environment_variables
  }
  #provisioner "local-exec" {
  #  command = (local.is_mysql
  #    ? "echo \"CREATE USER IF NOT EXISTS '${var.username}' IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS' | ${local.mysql_command}"
  #    : "echo \"CREATE USER ${var.username}; GRANT rds_iam TO ${var.username}\" | ${local.postgres_command}"
  #  )
  #  environment = local.database_environment_variables
  #}
  provisioner "local-exec" {
    command = (local.is_mysql
      ? "echo \"CREATE USER IF NOT EXISTS '${local.username}' IDENTIFIED BY '${local.password}'\" | ${local.mysql_command}"
      : "echo \"CREATE USER ${local.username} WITH PASSWORD '${local.password}; \" | ${local.postgres_command}"
    )
    environment = local.database_environment_variables
  }
  provisioner "local-exec" {
    command = (local.is_mysql
      ? "echo \"GRANT ALL PRIVILEGES ON ${local.database}.* TO '${local.username}'@'%'\" | ${local.mysql_command}"
      : "echo \"ALTER DATABASE ${local.database} OWNER TO ${local.username}\" | ${local.postgres_command}"
    )
    environment = local.database_environment_variables
  }
  #provisioner "local-exec" {
  #  when = destroy
  #  command = (local.is_mysql
  #    ? "DROP USER '${local.username}'@'%';"
  #    : "DROP USER ${local.username};"
  #  )
  #}
  #provisioner "local-exec" {
  #  when = destroy
  #  command = (local.is_mysql
  #    ? "echo 'DROP DATABASE ${local.database}' | ${local.mysql_command}"
  #    : "echo 'DROP DATABASE ${local.database}' | ${local.postgres_command}"
  #  )
  #}
}