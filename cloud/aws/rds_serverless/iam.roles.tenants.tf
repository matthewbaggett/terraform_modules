resource "aws_iam_role" "ec2_access" {
  for_each              = var.tenants
  name                  = join("-", ["RDS", title(var.instance_name), title(each.value.username), "EC2Access"])
  path                  = aws_iam_role.rds.path
  force_detach_policies = true
  assume_role_policy    = data.aws_iam_policy_document.ec2_connect_document.json
  tags = merge(
    try(var.application.application_tag, {}),
    {}
  )
}

resource "aws_iam_role" "user_access" {
  for_each              = var.tenants
  name                  = join("-", ["RDS", title(var.instance_name), title(each.value.username), "UserAccess"])
  path                  = aws_iam_role.rds.path
  force_detach_policies = true
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action" : ["sts:AssumeRole"]
    }]
  })
  tags = merge(
    try(var.application.application_tag, {}),
    {}
  )
}
resource "aws_iam_policy_attachment" "policy" {
  for_each   = var.tenants
  name       = join("-", ["RDS", title(var.instance_name), title(each.value.username), "Policy"])
  policy_arn = aws_iam_policy.read_only_policy[each.key].arn
  roles = [
    aws_iam_role.ec2_access[each.key].name,
    aws_iam_role.user_access[each.key].name
  ]
}
resource "aws_iam_group" "user_access" {
  for_each = var.tenants
  name     = join("-", ["RDS", title(var.instance_name), title(each.value.username), "UserAccess"])
}
resource "aws_iam_group_policy" "user_access" {
  for_each = var.tenants
  name     = join("-", ["RDS", title(var.instance_name), title(each.value.username), "ConnectPolicy"])
  policy   = data.aws_iam_policy_document.user_connect_policy_document[each.key].json
  group    = aws_iam_group.user_access[each.key].name
}
