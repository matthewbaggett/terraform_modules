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
resource "random_integer" "subnet_ip_octet" {
  for_each = local.ranges
  min      = local.ranges[each.key].min
  max      = local.ranges[each.key].max
}

locals {
  // Generate a subnet
  subnet = var.subnet != null ? var.subnet : "172.${random_integer.subnet_ip_octet["high"].result}.${random_integer.subnet_ip_octet["low"].result}.0/24"
  // Calculate the gateway from the subnet
  gateway = cidrhost(local.subnet, 1)
}