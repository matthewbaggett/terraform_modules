output "curl" {
  value = {
    "socks" = "curl -x ${local.socks_endpoint} https://ifconfig.me"
    "http"  = "curl -x ${local.http_endpoint} https://ifconfig.me"
  }
}
output "socks_endpoint" {
  value = local.socks_endpoint
}
output "http_endpoint" {
  value = local.http_endpoint
}
output "socks_port" {
  value = var.socks_proxy_port
}
output "http_port" {
  value = var.http_proxy_port
}
output "username" {
  value = local.username
}
output "password" {
  value = local.password
}