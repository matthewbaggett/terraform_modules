terraform {
  required_version = "~> 1.6"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    htpasswd = {
      source  = "loafoe/htpasswd"
      version = "~> 1.0"
    }
    json-formatter = {
      source  = "TheNicholi/json-formatter"
      version = "~> 0.1"
    }
    scratch = {
      source  = "BrendanThompson/scratch"
      version = "~> 0.4"
    }
  }
}


