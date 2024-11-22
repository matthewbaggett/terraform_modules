variable "nginx_hostname" {
  type    = string
  default = null
}
variable "acme_certificate" {
  type = object({
    private_key_pem = string
    certificate_pem = string
    issuer_pem      = string
  })
  default = null
}
module "nginx_config" {
  count         = var.nginx_hostname != null ? 1 : 0
  source        = "../nginx/site-available"
  service_name  = module.service.service_name
  hostname      = var.nginx_hostname
  upstream_host = "${module.service.service_name}:8080"
  config_prefix = module.service.service_name
  certificate   = var.acme_certificate
}
output "nginx_files" {
  value = var.nginx_hostname != null ? module.nginx_config[0].files : []
}