terraform {
  required_version = "~> 0.13.0"

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
  version = "~> 2.70"

  profile = "terraform"
  region  = "us-east-1"
}
