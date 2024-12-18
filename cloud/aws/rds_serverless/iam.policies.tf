resource "aws_iam_policy" "user_connect_policy" {
  for_each    = var.tenants
  name        = join("-", ["RDS", var.instance_name, each.value.username, "UserConnectPolicy"])
  path        = "/RDS/${var.instance_name}/${each.value.username}/"
  description = "Allow DB Access to EC2"
  policy      = data.aws_iam_policy_document.user_connect_policy_document[each.key].json
}
resource "aws_iam_policy" "ec2_connect_policy" {
  for_each    = var.tenants
  name        = join("-", ["RDS", var.instance_name, each.value.username, "EC2ConnectPolicy"])
  path        = "/RDS/${var.instance_name}/${each.value.username}/"
  description = "Allow DB Access to EC2"
  policy      = data.aws_iam_policy_document.aws_policy_document.json
}

# Read only access policy
resource "aws_iam_policy" "read_only_policy" {
  for_each    = var.tenants
  name        = join("-", ["RDS", title(var.instance_name), each.value.username, "ReadOnlyPolicy"])
  path        = "/RDS/${var.instance_name}/${each.value.username}/"
  description = "Allow Read DB Access to EC2"
  policy      = data.aws_iam_policy_document.read_only_policy[each.key].json
}

# Read-Write access policy
resource "aws_iam_policy" "read_write_policy" {
  for_each    = var.tenants
  name        = join("-", ["RDS", title(var.instance_name), each.value.username, "ReadWritePolicy"])
  policy      = data.aws_iam_policy_document.read_write_policy[each.key].json
  path        = "/RDS/${var.instance_name}/${each.value.username}/"
  description = "Allow Write DB access to EC2"
}