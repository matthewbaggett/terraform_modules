resource "aws_iam_role" "rds" {
  assume_role_policy    = data.aws_iam_policy_document.ec2_connect_document.json
  name                  = join("-", ["RDS", title(var.instance_name), ])
  path                  = "/${join("/", [var.application.name, "RDS", ])}/"
  force_detach_policies = true
  tags = merge(
    try(var.application.application_tag, {}),
    {}
  )
}
resource "aws_iam_policy_attachment" "rds_to_tenants" {
  for_each   = var.tenants
  name       = join("-", ["RDS", title(var.instance_name), title(each.value.username), "SupervisorConnectPolicy"])
  roles      = [aws_iam_role.rds.name]
  policy_arn = aws_iam_policy.user_connect_policy[each.key].arn
}
