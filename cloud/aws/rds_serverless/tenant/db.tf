locals {
  is_mysql = var.engine == "aurora-mysql"
  db_tunnel_remote = {
    host = data.aws_rds_cluster.cluster.endpoint
    port = local.is_mysql ? 3306 : 5432
  }
  mysql_command    = "${var.mysql_binary} -h ${data.ssh_tunnel.db.local.host} -P ${data.ssh_tunnel.db.local.port} -u ${var.admin_username}"
  postgres_command = "${var.postgres_binary} -h ${data.ssh_tunnel.db.local.host} -p ${data.ssh_tunnel.db.local.port} -U ${var.admin_username} -d ${var.admin_username}"
  database_environment_variables = {
    PGPASSWORD = !local.is_mysql ? var.admin_password : null,
    MYSQL_PWD  = local.is_mysql ? var.admin_password : null,
  }
}
resource "local_file" "debug" {
  filename = "${path.root}/.debug/aws/rds/serverless/${data.aws_rds_cluster.cluster.cluster_identifier}/${local.username}.json"
  content = jsonencode({
    db_tunnel_remote               = local.db_tunnel_remote,
    mysql_command                  = local.mysql_command,
    postgres_command               = local.postgres_command,
    database_environment_variables = local.database_environment_variables,
  })
  file_permission = "0600"
}
data "ssh_tunnel" "db" {
  connection_name = "db-${var.engine}"
  remote          = local.db_tunnel_remote
}
resource "terraform_data" "db" {
  triggers_replace = {
    engine     = data.aws_rds_cluster.cluster.engine,
    cluster_id = data.aws_rds_cluster.cluster.id
  }
  provisioner "local-exec" {
    command = "echo 'Connecting to \"${local.db_tunnel_remote.host}:${local.db_tunnel_remote.port}\" as \"${var.admin_username}\" via \"${data.ssh_tunnel.db.connection_name}\"'"
  }
  provisioner "local-exec" {
    command = (local.is_mysql
      ? "echo 'CREATE DATABASE IF NOT EXISTS ${var.database}' | ${local.mysql_command}"
      : "echo 'CREATE DATABASE ${var.database}' | ${local.postgres_command}"
    )
    environment = local.database_environment_variables
  }
  provisioner "local-exec" {
    command = (local.is_mysql
      ? "echo \"CREATE USER IF NOT EXISTS '${var.username}' IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS' | ${local.mysql_command}"
      : "echo \"CREATE USER ${var.username}; GRANT rds_iam TO ${var.username}\" | ${local.postgres_command}"
    )
    environment = local.database_environment_variables
  }
  provisioner "local-exec" {
    command = (local.is_mysql
      ? "GRANT ALL PRIVILEGES ON ${var.database}.* TO '${var.username}'@'%'\""
      : ""
    )
    environment = local.database_environment_variables
  }
  #provisioner "local-exec" {
  #  when = destroy
  #  command = (local.is_mysql
  #    ? "DROP USER '${var.username}'@'%';"
  #    : "DROP USER ${var.username};"
  #  )
  #}
  #provisioner "local-exec" {
  #  when = destroy
  #  command = (local.is_mysql
  #    ? "echo 'DROP DATABASE ${var.database}' | ${local.mysql_command}"
  #    : "echo 'DROP DATABASE ${var.database}' | ${local.postgres_command}"
  #  )
  #}
}