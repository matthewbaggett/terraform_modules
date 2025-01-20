data "aws_rds_certificate" "default" {
  id                = local.ca_cert_identifier
  latest_valid_till = true
}
data "http" "cert_data" {
  url = "https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem"
}
#output "cert" {
#  value = data.aws_rds_certificate.default
#}
#output "cert_data" {
#  value = data.http.cert_data.response_body
#}