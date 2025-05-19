resource "tls_private_key" "ca_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "tls_self_signed_cert" "ca_cert" {
  allowed_uses          = ["digital_signature", "cert_signing", "crl_signing", "key_encipherment"]
  private_key_pem       = tls_private_key.ca_private_key.private_key_pem
  validity_period_hours = var.certificate_expiry
  is_ca_certificate     = true
  subject {
    common_name         = var.lldap_ca_subject.common_name
    country             = var.lldap_ca_subject.country
    province            = var.lldap_ca_subject.province
    locality            = var.lldap_ca_subject.locality
    organization        = var.lldap_ca_subject.organization
    organizational_unit = var.lldap_ca_subject.organizational_unit
  }
}
resource "tls_private_key" "lldap_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "tls_cert_request" "lldap_crl" {
  private_key_pem = tls_private_key.lldap_key.private_key_pem
  dns_names       = [var.domain]
  subject {
    common_name         = var.domain
  }
}
resource "tls_locally_signed_cert" "lldap_cert" {
  #allowed_uses          = ["digital_signature", "key_encipherment", "server_auth", "client_auth"]
  allowed_uses = []
  set_subject_key_id = true
  ca_cert_pem           = tls_self_signed_cert.ca_cert.cert_pem
  ca_private_key_pem    = tls_private_key.ca_private_key.private_key_pem
  cert_request_pem      = tls_cert_request.lldap_crl.cert_request_pem
  validity_period_hours = var.certificate_expiry
}
/*
resource "local_file" "ca" {
  filename = "${path.module}/ca.pem"
  content  = tls_self_signed_cert.ca_cert.cert_pem
}
resource "local_file" "cert" {
  filename = "${path.module}/cert.pem"
  content  = tls_locally_signed_cert.lldap_cert.cert_pem
}
resource "local_file" "key" {
  filename = "${path.module}/key.pem"
  content  = tls_private_key.lldap_key.private_key_pem
}*/