terraform {
  #Terraform version at the time of writing this post
  required_version = ">= 0.12.24"

  backend "s3" {
    bucket = "github-terraform-aws-tfstates"
    key    = "infra.tfstate"
    region = "us-west-1"
  }
}

## provider "random" {}

## Provider us-west-1
provider "aws" {
  region = "us-west-1"
}