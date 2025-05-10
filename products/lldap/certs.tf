
# Generate a Cert and Key for the LDAP server
resource "tls_private_key" "lldap_cert" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
resource "tls_self_signed_cert" "lldap_cert" {
  //key_algorithm         = tls_private_key.lldap_cert.algorithm
  private_key_pem       = tls_private_key.lldap_cert.private_key_pem
  validity_period_hours = 365 * 24 * 10
  allowed_uses          = ["key_encipherment", "server_auth"]
  subject {
    common_name = var.domain
  }
}