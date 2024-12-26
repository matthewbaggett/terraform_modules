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
  value = join(" ", [
    "mysql",
    "-h", data.aws_rds_cluster.cluster.endpoint,
    "-P", data.aws_rds_cluster.cluster.port,
    "-D", local.database,
    "-u", local.username,
    "-p'${local.password}'",
  ])
}