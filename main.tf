terraform {
  #Terraform version
  required_version = ">= 0.12.24"

  backend "s3" {
    bucket = "github-terraform-aws-tfstates"
    key    = "infra.tfstate"
    region = "us-west-1"
  }
}

## Provider us-west-1
provider "aws" {
  region = "us-west-1"
}