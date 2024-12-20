output "username" {
  value = local.username
}
output "database" {
  value = local.database
}
output "access_key" {
  value = aws_iam_access_key.tenants.id
}
output "secret_key" {
  value = aws_iam_access_key.tenants.secret
}
output "auth_token" {
  value = data.external.rds_auth_token.result.password
}
output "connection_string" {
  value = join(" ", [
    "mysql",
    "-h", data.aws_rds_cluster.cluster.endpoint,
    "-P", data.aws_rds_cluster.cluster.port,
    "-D", local.database,
    "-u", local.username,
    "-p'${data.external.rds_auth_token.result.password}'",
  ])
}