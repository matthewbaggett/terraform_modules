data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "rds_instance_policy" {
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
resource "aws_iam_policy" "rds_instance_policy" {
  policy = data.aws_iam_policy_document.rds_instance_policy.json
  name   = join("", [local.app_name, "RDS", "InstancePolicy"])
  path   = "/${join("/", [local.app_name, "RDS", "InstancePolicy"])}/"
  tags = merge(
    try(var.application.application_tag, {}),
    {}
  )
}
resource "aws_iam_role" "rds_instance_policy" {
  assume_role_policy    = data.aws_iam_policy_document.assume_role_policy.json
  name                  = join("", [local.app_name, "RDS", ])
  path                  = "/${join("/", [local.app_name, "RDS", ])}/"
  force_detach_policies = true
  tags = merge(
    try(var.application.application_tag, {}),
    {}
  )
}

resource "aws_iam_policy_attachment" "rds_instance_policy" {
  name       = aws_iam_policy.rds_instance_policy.name
  policy_arn = aws_iam_policy.rds_instance_policy.arn
  roles      = [aws_iam_role.rds_instance_policy.name]
}