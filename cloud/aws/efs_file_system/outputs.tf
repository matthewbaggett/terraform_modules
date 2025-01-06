output "users" {
  value = {
    for user in var.users : user => { name = user, access_key = aws_iam_access_key.db_storage[user].id, secret_key = aws_iam_access_key.db_storage[user].secret }
  }
}
output "volume" {
  value = try(aws_efs_file_system.volume[0], null)
}
output "arn" {
  value = try(aws_efs_file_system.volume[0].arn, null)
}
output "availability_zone" {
  value = try(aws_efs_file_system.volume[0].availability_zone_name, null)
}
output "access_point" {
  value = aws_efs_access_point.access_point
}