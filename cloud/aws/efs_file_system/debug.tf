resource "local_file" "debug" {
  filename = "${path.root}/.debug/aws/s3_efs/efs.${var.volume_name}.json"
  content = jsonencode({
    volume_name = var.volume_name,
    tags        = local.tags,
  })
  file_permission = "0600"
}