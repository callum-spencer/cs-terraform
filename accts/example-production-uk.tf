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
    bucket         = "s3-example-prod-uk-tf-state"
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
  default = "6546849813"
}

variable "aws_region" {
  type = string
  default = "eu-west-2"
}

variable "aws_default_region" {
  type = string
  default = "eu-west-2"
}

variable "vpc_id" {
  type = string
  default = "vpc-6555651356"
}

variable "public_subnet_ids" {
 type = list
 default = ["subnet-65468714684","subnet-6468451361468"]
}

variable "private_subnet_ids" {
 type = list
 default = ["subnet-65468448","subnet-6546865315"]
}