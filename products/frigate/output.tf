output "endpoint" {
  value = try("https://${var.traefik.domain}", "unknown")
}