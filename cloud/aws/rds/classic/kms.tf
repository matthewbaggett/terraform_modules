resource "aws_kms_key" "db_key" {
  # trivy:ignore:AVD-AWS-0065
  description = "RDS ${var.instance_name} Encryption Key"
  tags = merge(
    try(var.application.application_tag, {}),
    {
      TerraformSecretType = "RDSMasterEncryptionKey"
    }
  )
}