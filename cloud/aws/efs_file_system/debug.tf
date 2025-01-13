resource "local_file" "debug" {
  filename = "${path.root}/.debug/aws/efs/efs.${var.volume_name}.json"
  content = jsonencode({
    volume_name        = local.volume_name,
    display_name       = local.display_name,
    efs_tags           = local.efs_tags
    efs_ap_tags        = local.efs_ap_tags
    security_group_ids = local.security_group_ids
    dns_name           = aws_efs_file_system.volume.dns_name
    users              = var.users
  })
  file_permission = "0600"
}