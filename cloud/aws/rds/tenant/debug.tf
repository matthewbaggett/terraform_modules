/***
 * HEADS UP!
 * If you're in here, you've probably got an issue with connecting to the database and pushing
 * new data/tenants to it.
 *
 * Check first:
 * 1. Can the gateway server contact the database? Check the Security Groups!
 * 2. Is the ssh tunnel being created right?
 */

resource "scratch_string" "debug" {
  in = yamlencode({
    engine      = var.engine
    is_mysql    = local.is_mysql
    is_postgres = local.is_postgres
    #tunnel = module.tunnel
    bastion = var.bastion
  })
}

resource "local_file" "debug" {
  filename = "${local.debug_path}/${local.username}.json"
  content = jsonencode({
    db_tunnel_remote = local.db_tunnel_remote,
    #mysql_command                  = local.mysql_command,
    #postgres_command               = local.postgres_command,
    database_environment_variables = local.database_environment_variables,
    bastion                        = var.bastion,
  })
  file_permission = "0600"
}