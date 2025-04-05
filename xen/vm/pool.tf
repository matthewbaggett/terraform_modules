variable "pool_name" {
  type        = string
  description = "The name of the pool"
}
data "xenorchestra_pool" "pool" {
  name_label = var.pool_name
}