variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "retention_period" {
  type    = number
  default = 90
}