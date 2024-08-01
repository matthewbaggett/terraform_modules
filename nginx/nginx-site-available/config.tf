locals {
  auth = var.basic_auth != null ? "${var.basic_auth.username}:${htpasswd_password.hash[0].bcrypt}\n" : null
  config = templatefile("${path.module}/nginx_template.conf", {
    hostname         = var.hostname
    service_name     = var.service_name
    http_port        = var.http_port
    https_port       = var.https_port
    upstream_host    = var.upstream_host
    enable_ssl       = var.certificate != null
    certificate      = var.certificate
    basic_auth       = var.basic_auth
    auth_file        = var.basic_auth != null ? "${var.hostname}.auth" : ""
    allow_non_ssl    = var.allow_non_ssl
    redirect_non_ssl = var.redirect_non_ssl
    timeout_seconds  = var.timeout_seconds
    host_override    = var.host_override
    extra_upstreams  = var.extra_upstreams
    extra_config     = var.extra_config
    extra_locations  = var.extra_locations
  })
  cert_public  = "${var.certificate.issuer_pem}${var.certificate.certificate_pem}"
  cert_private = var.certificate.private_key_pem
  filenames = {
    nginx           = "${var.hostname}.conf"
    auth            = "${var.hostname}.auth"
    certificate_key = "${var.hostname}.key"
    certificate     = "${var.hostname}.crt"
  }
  files = [for f in [
    {
      file = local.filenames.nginx
      name = docker_config.nginx_site_available.name
      id   = docker_config.nginx_site_available.id
    },
    var.basic_auth != null ? {
      file = local.filenames.auth
      name = docker_config.auth[0].name
      id   = docker_config.auth[0].id
    } : null,
    var.certificate != null ? {
      file = local.filenames.certificate
      name = docker_config.certificate[0].name
      id   = docker_config.certificate[0].id
    } : null,
    var.certificate != null ? {
      file = local.filenames.certificate_key
      name = docker_config.certificate_key[0].name
      id   = docker_config.certificate_key[0].id
    } : null
  ] : f if f != null]
}

# Nginx config
resource "random_id" "config_instance" {
  byte_length = 4
  keepers = {
    config : local.config,
    auth : local.auth,
    cert_public : local.cert_public,
    cert_private : local.cert_private,
  }
}
resource "docker_config" "nginx_site_available" {
  name = join(".", [var.config_prefix, "conf", var.hostname, random_id.config_instance.id])
  data = base64encode(local.config)
}

resource "local_file" "nginx_site_available" {
  filename = "${path.root}/.debug/nginx/${local.filenames.nginx}"
  content  = local.config
}
