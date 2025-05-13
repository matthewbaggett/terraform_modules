output "username" {
  value = local.username
}
output "password" {
  value = local.password
}
output "database" {
  value = local.database
}

output "connection_string" {
  value = local.is_mysql ? join(" ", [
    "mysql",
    "-h", var.endpoint.host,
    "-P", var.endpoint.port,
    "-D", local.database,
    "-u", local.username,
    "-p'${local.password}'",
    ]) : join(" ", [
    "psql",
    "-h", var.endpoint.host,
    "-p", var.endpoint.port,
    "-d", local.database,
    "-U", local.username,
    "-W",
  ])
}