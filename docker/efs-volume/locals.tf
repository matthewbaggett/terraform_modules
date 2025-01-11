locals {
  # @todo MB: fix volume name its janky
  volume_name        = trimspace(lower(replace(replace(local.display_name, "/\\W|_|\\s/", ""), " ", "-")))
  display_name       = trimspace(var.volume_name)
  display_name_ascii = replace(local.display_name, "/[^a-zA-Z0-9 ]/", "")
  alias              = "efs-${local.volume_name}"
  iam_user           = "${var.stack_name}-efs-${local.volume_name}"
  users              = [local.iam_user]
  ebs_volume_name    = var.bucket_name == null ? local.volume_name : var.bucket_name
  access_key         = nonsensitive(module.efs_file_system.users[local.iam_user].access_key)
  secret_key         = nonsensitive(module.efs_file_system.users[local.iam_user].secret_key)
  rexray_env = [
    "REXRAY_LOGLEVEL=warn",
    "EFS_ACCESSKEY=${local.access_key}",
    "EFS_SECRETKEY=${local.secret_key}",
    "EFS_REGION=${data.aws_region.current.name}",
    "EFS_SECURITYGROUPS=\"${join(" ", module.efs_file_system.security_group_ids)}\"",
    "CSI_ENDPOINT=",
    "DOCKER_LEGACY=true",
    "EFS_DISABLESESSIONCACHE=",
    "EFS_STATUSINITIALDELAY=",
    "EFS_STATUSMAXATTEMPTS=",
    "EFS_STATUSTIMEOUT=",
    "EFS_TAG=",
    "HTTP_PROXY=",
    "LIBSTORAGE_INTEGRATION_VOLUME_OPERATIONS_MOUNT_ROOTPATH=",
    "LINUX_VOLUME_FILEMODE=",
    "LINUX_VOLUME_ROOTPATH=",
    "REXRAY_PREEMPT=false",
    "X_CSI_DRIVER=",
    "X_CSI_NATIVE=",
  ]
}
data "aws_region" "current" {}
