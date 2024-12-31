variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "project_name" {
  type = string
}

variable "scaling_metric_name" {
  type = string
}

variable "scaling_metric_alarm_name" {
  type = string
}

variable "scaling_up_threshold" {
  type    = string
  default = "90"
}

variable "scaling_down_threshold" {
  type    = string
  default = "10"
}

variable "scaling_metric_aggregation" {
  type    = string
  default = "Maximum"
}

variable "scaling_wait_time" {
  type    = string
  default = "10"
}

variable "autoscaling_target_id" {
  type    = string
}

variable "environment" {
  type = string
}