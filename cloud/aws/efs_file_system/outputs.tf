output "users" {
  value = {
    for index, user in var.users : user => {
      name       = user,
      access_key = aws_iam_access_key.db_storage[index].id,
      secret_key = aws_iam_access_key.db_storage[index].secret
    }
  }
}
output "volume" {
  value = try(aws_efs_file_system.volume, null)
}
output "arn" {
  value = try(aws_efs_file_system.volume.arn, null)
}
output "availability_zone" {
  value = try(aws_efs_file_system.volume.availability_zone_name, null)
}
output "access_point" {
  value = aws_efs_access_point.access_point
}
output "dns_name" {
  value = aws_efs_file_system.volume.dns_name
}
output "security_group_ids" {
  value = [aws_security_group.efs.id]
}