terraform {
  required_version = "~> 1.1.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # Replace this as appropriate
  cloud {
    organization = "Artis3nal"
    workspaces {
      name = "cloud-hackbox-kali"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
