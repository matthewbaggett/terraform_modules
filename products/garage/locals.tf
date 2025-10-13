locals {
  env = {
    rpc_public_addr = "disks.home.grey.ooo:${var.rpc_port}"
    rpc_secret = "99701f10373c25bfefd89a010c1fd29c83ed36abf0af67f6b9fcc53fe23cf719"
    rpc_port       = var.rpc_port
    s3_port        = var.s3_port
    web_port       = var.web_port
    s3_region      = var.s3_region
    domain         = var.domain
  }
}