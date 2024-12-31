provider "aws" {
  region     = "eu-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/fulladmin"
  }
}

terraform {
  backend "s3" {
    bucket         = "s3-pw-cimg-def-tf-state"
    # The line below is overridden by the terraform apply so just needs to be in there for the Terraform syntax checker
    key            = "genericservice-service.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform_locks"
  }
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_account_id" {
  type = string
  default = "12154541244"
}