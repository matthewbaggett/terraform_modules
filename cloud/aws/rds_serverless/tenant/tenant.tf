data "aws_arn" "tenant" {
  arn = join(":", [
    "arn", "aws", "rds-db",
    data.aws_region.current.name,
    data.aws_caller_identity.current.account_id,
    "dbuser",
    "${lower(data.aws_rds_cluster.cluster.cluster_resource_id)}/${local.username}"
  ])
}
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
data "aws_iam_policy_document" "tenant_user_policy_document" {
  statement {
    actions   = ["rds-db:*"]
    effect    = "Allow"
    resources = [data.aws_arn.tenant.arn]
  }
}

# Create IAM and key for each tenant
resource "aws_iam_user" "tenant" {
  name = join("", ["RDS", var.app_name, title(local.username)])
  tags = var.tags
  path = "/${join("/", [var.app_name, "RDS", title(local.username), ])}/"
}

data "external" "rds_auth_token" {
  program = [
    "bash", "-c", replace(
      <<-EOF
        aws
          --profile ${var.aws_profile}
          rds
            generate-db-auth-token
              --hostname  ${data.aws_rds_cluster.cluster.endpoint}
              --port      ${data.aws_rds_cluster.cluster.port}
              --region    ${replace(data.aws_region.current.name, "/[[:lower:]]$/", "")}
              --username  ${local.username}
        | jq --raw-input '{ password: . }'
      EOF
    , "\n", " ")
  ]
}

# Here's that key we were just talking about
resource "aws_iam_access_key" "tenants" {
  user   = aws_iam_user.tenant.name
  status = var.is_active ? "Active" : "Inactive"
}

# Make a role for the IAM user to assume
resource "aws_iam_role" "rds_instance_policy_per_user" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name               = join("", [var.app_name, "RDS", "Tenant", title(local.username), ])
  path               = "/${join("/", [var.app_name, "RDS", "Tenant", title(local.username), ])}/"
  tags               = var.tags
}

# Create a policy per-tenant
resource "aws_iam_policy" "tenant_policy" {
  name        = join("", [var.app_name, "RDS", title(local.username), "TenantUserPolicy"])
  path        = "/RDS/${var.app_name}/${local.username}/"
  description = "Allow user ${local.username} Data Access to RDS database ${local.database}"
  policy      = data.aws_iam_policy_document.tenant_user_policy_document.json
  tags        = var.tags
}

# find the superuser role if supplied
data "aws_iam_role" "superuser" {
  count = var.super_user_iam_role_name != null ? 1 : 0
  name  = var.super_user_iam_role_name
}
# Attach the tenant policy role to the tenants role
resource "aws_iam_policy_attachment" "tenant_policy_attachment" {
  name       = join("", [var.app_name, "RDS", title(local.username), "TenantUserPolicyAttachment"])
  policy_arn = aws_iam_policy.tenant_policy.arn
  roles = compact([
    aws_iam_role.rds_instance_policy_per_user.name,
    try(data.aws_iam_role.superuser[0].name, null)
  ])
}

# Create the tenants own group
resource "aws_iam_group" "tenant" {
  name = join("", [var.app_name, "RDS", title(local.username), "TenantGroup"])
  path = "/${join("/", [var.app_name, "RDS", title(local.username), ])}/"
}

# Attach the tenant role to the tenant group
resource "aws_iam_group_policy_attachment" "tenant_policy_attachment" {
  group      = aws_iam_group.tenant.name
  policy_arn = aws_iam_policy.tenant_policy.arn
}

# Attach the tenant user to the tenant group
resource "aws_iam_group_membership" "tenant" {
  name  = join("", [var.app_name, "RDS", title(local.username), "TenantGroupMembership"])
  group = aws_iam_group.tenant.name
  users = [aws_iam_user.tenant.name]
}