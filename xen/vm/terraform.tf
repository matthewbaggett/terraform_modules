terraform {
  required_version = "~> 1.6"

  required_providers {
    xenorchestra = {
      source  = "terra-farm/xenorchestra"
      version = "~> 0.26"
    }
  }
}