provider "aws" {
  region     = "eu-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

terraform {
  backend "s3" {
    bucket         = "s3-pw-usr-tf-state"
    key            = "users-service.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform_locks"
  }
}