resource "aws_iam_user" "db_storage" {
  for_each = toset(var.users)
  name     = each.value
  tags     = var.tags
}
data "aws_iam_policy_document" "db_storage" {
  for_each = toset(var.users)
  statement {
    actions = [
      "elasticfilesystem:*",
      "elasticfilesystem:CreateFileSystem",
      "elasticfilesystem:CreateMountTarget",
      "ec2:DescribeSubnets",
      "ec2:DescribeNetworkInterfaces",
      "ec2:CreateNetworkInterface",
      "elasticfilesystem:CreateTags",
      "elasticfilesystem:DeleteFileSystem",
      "elasticfilesystem:DeleteMountTarget",
      "ec2:DeleteNetworkInterface",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeMountTargets"
    ]
    resources = [
      "arn:aws:elasticfilesystem:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:file-system/*",
    ]
    effect = "Allow"
  }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
resource "aws_iam_user_policy" "db_storage" {
  for_each = toset(var.users)
  name     = "efs_policy_${each.value}_to_${var.volume_name}"
  user     = aws_iam_user.db_storage[each.key].name
  policy   = data.aws_iam_policy_document.db_storage[each.key].json
}
resource "aws_iam_access_key" "db_storage" {
  for_each = toset(var.users)
  user     = aws_iam_user.db_storage[each.key].name
}
