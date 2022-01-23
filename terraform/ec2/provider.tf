terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.72.0"
    }
  }
  backend "s3" {
  }
}

provider "aws" {
  region = "us-east-1"
}
