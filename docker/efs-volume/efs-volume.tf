locals {
  # Sanitise the volume name - strip non-alphanumeric characters and replace spaces and underscores with hyphens
  volume_name     = replace(replace(replace(lower(var.volume_name), "[^a-z0-9]", ""), "[ _]", "-"), "--", "-")
  alias           = "efs-${local.volume_name}"
  iam_user        = "${var.stack_name}-efs-${local.volume_name}"
  ebs_volume_name = var.bucket_name == null ? local.volume_name : var.bucket_name
  access_key      = nonsensitive(module.efs_file_system.users[local.iam_user].access_key)
  secret_key      = nonsensitive(module.efs_file_system.users[local.iam_user].secret_key)
}
resource "docker_plugin" "efs" {
  depends_on = [module.efs_file_system]
  name       = var.image_efs_plugin
  alias      = local.alias
  enabled    = true
  grant_permissions {
    name  = "network"
    value = ["host"]
  }
  grant_permissions {
    name  = "mount"
    value = ["/dev"]
  }
  grant_permissions {
    name  = "allow-all-devices"
    value = ["true"]
  }
  grant_permissions {
    name  = "capabilities"
    value = ["CAP_SYS_ADMIN"]
  }
  env = [
    "REXRAY_LOGLEVEL=warn",
    "EFS_ACCESSKEY=${local.access_key}",
    "EFS_SECRETKEY=${local.secret_key}",
    "EFS_REGION=${data.aws_region.current.name}",
    "EFS_SECURITYGROUPS=\"${join(" ", var.security_group_ids)}\"",
  ]
  lifecycle {
    create_before_destroy = false
  }
}

data "aws_region" "current" {}

module "efs_file_system" {
  source              = "../../cloud/aws/efs_file_system"
  volume_name         = var.volume_name
  users               = [local.iam_user]
  tags                = merge(var.tags, { Name = var.volume_name }, coalesce(var.application.application_tag, {}))
  ia_lifecycle_policy = var.ia_lifecycle_policy
  security_group_ids  = var.security_group_ids
  create_fs           = false
}
module "volume" {
  depends_on           = [docker_plugin.efs, ]
  source               = "../../docker/volume"
  stack_name           = var.stack_name
  volume_name          = local.volume_name
  volume_name_explicit = true
  driver               = local.alias
}
output "volume" {
  value = module.volume.volume
}