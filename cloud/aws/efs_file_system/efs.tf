resource "aws_efs_file_system" "volume" {
  creation_token = local.volume_name
  lifecycle_policy {
    transition_to_ia = var.ia_lifecycle_policy
  }
  tags            = local.efs_tags
  encrypted       = true
  throughput_mode = "elastic"
}
resource "aws_efs_access_point" "access_point" {
  file_system_id = aws_efs_file_system.volume.id
  root_directory {
    path = "/"
  }
  tags = local.efs_ap_tags
}
resource "aws_efs_mount_target" "mount_target" {
  for_each       = { for subnet in distinct(var.subnet_ids) : subnet => subnet }
  file_system_id = aws_efs_file_system.volume.id
  subnet_id      = each.value
}