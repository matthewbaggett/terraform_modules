terraform {
  required_version = "~> 1.6"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.5"
    }
    local = {
      source  = "hashicorp/local"
      version = "~>2.1"
    }
    scratch = {
      source  = "BrendanThompson/scratch"
      version = "0.4.0"
    }
    htpasswd = {
      source  = "loafoe/htpasswd"
      version = "1.2.1"
    }
  }
}


