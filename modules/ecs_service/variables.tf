variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "environment_short" {
  type = string
  default = "default"
}

variable "app_image" {
  type = string
}

variable "fargate_cpu" {
  type = string
}

variable "fargate_memory" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "app_port" {
  type    = string
  default = 64141
  # This is needed for the Security group attached to the ecs service but could be made conditional
}

variable "app_port_protocol" {
  type = string
  default = "tcp"
}

variable "ecs_task_execution_role" {
  type = string
  default = ""
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list
}

variable "target_group_arn" {
  type    = string
  default = ""
}

variable "app_count" {
  type = string
}

variable "ecs_cluster" {
  type = string
}

variable "ecs_task_secgrp_id" {
  type = string
}

variable "overall_cpu" {
  type = string
}

variable "overall_memory" {
  type = string
}

variable "application_lb" {
  default = true
  type = bool
}

variable "network_lb" {
  type = bool
  default = false
}

variable "elb_name" {
  type = string
  default = "notsupplied"
}

variable "link_to_lb" {
  type = bool
  default = false
}

variable "custom_cluster_name" {
  type = string
  default = ""
}

variable "task_execution_role_arn" {
  type = string
}

variable "task_storage_in_gib" {
  type = number
  default = 25
}