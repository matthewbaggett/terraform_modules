terraform {
  required_version = "~> 1.6"

  required_providers {
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
    remote = {
      source  = "tenstad/remote"
      version = "~> 0.1"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
    scratch = {
      source  = "BrendanThompson/scratch"
      version = "~> 0.4"
    }
  }
}