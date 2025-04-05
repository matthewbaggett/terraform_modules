terraform {
  required_version = "~> 1.6"

  required_providers {
    xenorchestra = {
      source  = "vatesfr/xenorchestra"
      version = "~> 0.31.1"
    }
    macaddress = {
      source  = "ivoronin/macaddress"
      version = "~> 0.3"
    }
    remote = {
      source  = "tenstad/remote"
      version = "~> 0.1"
    }
  }
}