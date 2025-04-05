data "xenorchestra_template" "template" {
  name_label = var.template
}
data "xenorchestra_network" "net" {
  name_label = var.network
}
data "xenorchestra_sr" "local_storage" {
  name_label = var.storage.vm
}
data "xenorchestra_sr" "isos" {
  name_label = var.storage.iso
}
resource "random_pet" "pet_name" {}
