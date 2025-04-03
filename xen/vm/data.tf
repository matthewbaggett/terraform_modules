data "xenorchestra_pool" "pool" {
  name_label = var.pool_name
}

data "xenorchestra_template" "template" {
  name_label = var.template
}

data "xenorchestra_network" "net" {
  name_label = var.network
}
