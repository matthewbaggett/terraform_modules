resource "local_file" "debug" {
  filename = "${path.root}/.debug/aws/efs/rexray_plugin.json"
  content = jsonencode({
    env                 = local.rexray_env
    alias               = local.alias
    ia_lifecycle_policy = var.ia_lifecycle_policy
    name                = var.image_efs_plugin
    users               = local.users
  })
  file_permission = "0600"
}