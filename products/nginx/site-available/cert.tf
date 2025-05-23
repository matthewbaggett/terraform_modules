resource "docker_config" "certificate" {
  count = var.certificate != null ? 1 : 0
  name  = join(".", [var.config_prefix, "crt", var.hostname, random_id.config_instance.id])
  data  = base64encode("${var.certificate.certificate_pem}${var.certificate.issuer_pem}")
  lifecycle {
    create_before_destroy = true
  }
}
resource "local_file" "certificate" {
  count           = var.certificate != null ? 1 : 0
  content         = local.cert_public
  filename        = "${path.root}/.debug/nginx/${local.filenames.certificate}"
  file_permission = "0600"
}
resource "docker_config" "certificate_key" {
  count = var.certificate != null ? 1 : 0
  name  = join(".", [var.config_prefix, "key", var.hostname, random_id.config_instance.id])
  data  = base64encode(local.cert_private)
  lifecycle {
    create_before_destroy = true
  }
}
resource "local_file" "certificate_key" {
  count           = var.certificate != null ? 1 : 0
  content         = var.certificate.private_key_pem
  filename        = "${path.root}/.debug/nginx/${local.filenames.certificate_key}"
  file_permission = "0600"
}
