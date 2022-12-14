terraform {
  required_version = ">= 1.0"
  backend "remote" {
    organization = "staloosh"

    workspaces {
      name = "personal-project-workspace"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}