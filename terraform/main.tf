
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

resource "docker_image" "cv_image" {
  name = "nour292/examen:latest"
}

resource "docker_container" "moncv" {
  name  = "moncv"
  image = docker_image.cv_image.name
  ports {
    internal = 80
    external = 8585
  }
}

