locals {
  # @todo MB: fix volume name its janky
  volume_name        = trim(replace(local.display_name_ascii, " ", "-"), "-")
  display_name_ascii = trimspace(replace(var.volume_name, "/[^a-zA-Z0-9_ ]/", " "))
  iam_user           = "${title(var.stack_name)}-EFS-${title(local.volume_name)}"
  users              = [local.iam_user]
  access_key         = nonsensitive(module.efs_file_system.users[local.iam_user].access_key)
  secret_key         = nonsensitive(module.efs_file_system.users[local.iam_user].secret_key)
}
data "aws_region" "current" {}
