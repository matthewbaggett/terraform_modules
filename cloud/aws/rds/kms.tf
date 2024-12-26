resource "aws_kms_key" "db_key" {
  description = "RDS ${var.instance_name} Encryption Key"
  tags = merge(
    try(var.application.application_tag, {}),
    {
      TerraformSecretType = "RDSMasterEncryptionKey"
    }
  )
}