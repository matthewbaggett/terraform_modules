resource "docker_config" "default_page" {
  name = "${var.service_name}.index.html"
  data = base64encode("<h1>Hello, World!</h1>")
}
resource "local_file" "default_page" {
  content  = base64decode(docker_config.default_page.data)
  filename = "${path.module}/debug/index.html"
}
resource "docker_config" "default_conf" {
  name = "${var.service_name}.default.conf"
  data = base64encode(file("${path.module}/default.conf"))
}
resource "local_file" "default_conf" {
  content  = base64decode(docker_config.default_conf.data)
  filename = "${path.module}/debug/default.conf"
}
