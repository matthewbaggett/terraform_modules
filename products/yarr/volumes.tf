module "media" {
  source      = "../../docker/volume"
  stack_name  = var.stack_name
  volume_name = "media"
  bind_path   = var.bind_paths.media
}
module "books" {
  source      = "../../docker/volume"
  stack_name  = var.stack_name
  volume_name = "books"
  bind_path   = var.bind_paths.books
}