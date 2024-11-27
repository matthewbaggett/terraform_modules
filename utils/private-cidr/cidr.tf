resource "random_integer" "upper_mid_byte" {
  min = 18
  max = 31
}
resource "random_integer" "lower_mid_byte" {
  min = 10
  max = 254
}
locals {
  // Generate a subnet
  subnet = var.override_subnet != null ? "172.${random_integer.upper_mid_byte.result}.${random_integer.lower_mid_byte.result}.0/${var.subnet_mask}" : ""
  // Calculate the gateway from the subnet
  gateway = cidrhost(local.subnet, 1)
}

