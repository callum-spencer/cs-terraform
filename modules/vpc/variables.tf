variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of private subnet CIDR blocks"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones to use"
}

variable "app_port" {
  type        = number
  description = "Application port for ECS tasks"
}

variable "project_name" {
  type        = string
  description = "The name of the project"
}

variable "product_name" {
  type        = string
  description = "The name of the product"
}

variable "environment" {
  type        = string
  description = "The environment (e.g. dev, prod)"
}