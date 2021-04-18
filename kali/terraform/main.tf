terraform {
  required_version = "~> 0.15.0"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  # Replace this as appropriate for your backend
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Artis3nal"

    workspaces {
      name = "cloud-hackbox-kali"
    }
  }
}

provider "aws" {
  profile = "terraform"
  region  = "us-east-1"
}
