variable "prefix" {
    type = number
    default = 172
}
variable "subnet_mask" {
    type = number
    default = 24
}
variable "override_subnet" {
    type = string
    default = null
}