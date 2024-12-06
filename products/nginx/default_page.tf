locals {
  default_page = "<h1>Hello, World!</h1>"
}
resource "docker_config" "default_page" {
  name = "${var.service_name}.index.html-${substr(sha1(local.default_page), 0, 4)}"
  data = base64encode(local.default_page)
}
resource "local_file" "default_page" {
  content         = base64decode(docker_config.default_page.data)
  filename        = "${path.root}/.debug/nginx/index.html"
  file_permission = "0600"
}
resource "docker_config" "default_conf" {
  name = "${var.service_name}.default.conf-${substr(sha1(file("${path.module}/default.conf")), 0, 4)}"
  data = base64encode(file("${path.module}/default.conf"))
}
resource "local_file" "default_conf" {
  content         = base64decode(docker_config.default_conf.data)
  filename        = "${path.root}/.debug/nginx/default.conf"
  file_permission = "0600"
}
