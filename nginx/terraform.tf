terraform {
  required_version = "~> 1.6"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>3.0"
    }
    scratch = {
      source  = "BrendanThompson/scratch"
      version = "0.4.0"
    }
  }
}


