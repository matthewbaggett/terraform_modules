terraform {
  required_version = "~> 1.6"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    lldap = {
      source  = "tasansga/lldap"
      version = "~> 0.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}



