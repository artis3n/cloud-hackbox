terraform {
  required_version = "~> 0.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.22.0"
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
