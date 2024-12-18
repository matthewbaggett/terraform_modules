data "aws_iam_policy_document" "ec2_connect_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "aws_policy_document" {

  statement {
    actions   = ["iam:GetGroup"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions   = ["iam:GetSSHPublicKey", "iam:ListSSHPublicKeys"]
    effect    = "Allow"
    resources = ["arn:aws:iam::*:user/*"]
  }

  statement {
    actions   = ["ec2:*"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions   = ["rds:*"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    actions   = ["secretsmanager:*"]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "user_connect_policy_document" {
  for_each = var.tenants
  statement {
    actions   = ["rds-db:connect"]
    effect    = "Allow"
    resources = ["arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_rds_cluster_instance.instance.cluster_identifier}/${each.value.username}"]
  }
}

data "aws_iam_policy_document" "read_only_policy" {
  for_each = var.tenants
  statement {
    actions   = ["rds-db:connect"]
    effect    = "Allow"
    resources = ["arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_rds_cluster_instance.instance.cluster_identifier}/${each.value.username}"]
  }
}
data "aws_iam_policy_document" "read_write_policy" {
  for_each = var.tenants
  statement {
    actions   = ["rds-db:connect"]
    effect    = "Allow"
    resources = ["arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_rds_cluster_instance.instance.cluster_identifier}/${each.value.username}"]
  }
}