locals {
  ranges = {
    "low" = {
      "min" = 18
      "max" = 31
    }
    "high" = {
      "min" = 128
      "max" = 255
    }
  }
}
resource "random_integer" "subnet_ip_octet_high" {
  min = local.ranges.high.min
  max = local.ranges.high.max
}
resource "random_integer" "subnet_ip_octet_low" {
  min = local.ranges.low.min
  max = local.ranges.low.max
}

locals {
  // Generate a subnet
  subnet = var.subnet != null ? var.subnet : "172.${random_integer.subnet_ip_octet_high.result}.${random_integer.subnet_ip_octet_low.result}.0/24"
  // Calculate the gateway from the subnet
  gateway = cidrhost(local.subnet, 1)
}