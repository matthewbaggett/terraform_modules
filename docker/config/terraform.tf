terraform {
  required_version = "~> 1.6"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~>2.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.3"
    }
  }
}


