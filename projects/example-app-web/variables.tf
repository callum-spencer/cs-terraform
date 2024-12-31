variable "environment" {
  type = string
}

variable "environment_short" {
  type = string
}

variable "project_name" {
  type = string
}

variable "scaling_min_count" {
  type    = string
  default = "1"
}

variable "scaling_max_count" {
  type    = string
  default = "2"
}

variable "scaling_up_cpu_threshold" {
  type    = string
  default = "90"
}

variable "scaling_down_cpu_threshold" {
  type    = string
  default = "10"
}

variable "scaling_cpu_metric_aggregation" {
  type    = string
  default = "Maximum"
}

variable "scaling_wait_time" {
  type    = string
  default = "10"
}

variable "alb_certificate" {
  type    = string
  default = "*.exampledomain.com"
}

variable "target_group_port" {
  type    = string
  default = "80"
}

variable "target_group_protocol" {
  type    = string
  default = "HTTP"
}

variable "health_check_path" {
  type = string
}

variable "health_check_expected_port" {
  type    = string
  default = "200"
}

variable "health_check_healthy_threshold" {
  type    = string
  default = "3"
}

variable "health_check_interval" {
  type    = string
  default = "30"
}

variable "health_check_timeout" {
  type    = string
  default = "3"
}

variable "health_check_unhealthy_threshold" {
  type    = string
  default = "2"
}

variable "alb_https_listener_port" {
  type    = string
  default = "443"
}

variable "alb_redirect_status_code" {
  type    = string
  default = "HTTP_301"
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

variable "app_port" {
  type = string
}

variable "app_port_protocol" {
  type = string
  default = "tcp"
}

variable "ecs_task_execution_role" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "link_to_lb" {
  type = string
}

variable "app_count" {
  type = string
}

variable "overall_cpu" {
  type = string
  default = "4096"
}

variable "overall_memory" {
  type = string
  default = "8192"
}

variable "custom_cluster_name" {
  type        = string
  description = "Custom ECS cluster description, if any required"
  default     = ""
}

variable "product" {
  type = string
}

variable "ecs_autoscale_role" {
  type = string
}

variable "acm_certificate" {
  type = string
  default = "*.exampledomain.com"
}

variable "ecs_cluster_name" {
  type = string
}

variable "dns_subdomain" {
  default = "default"
  type = string
}

variable "ecs_scheduled_task" {
  default = "false"
}

variable "acl_enabled" {
  default = "0"
  type = string
}

variable "application_domains" {
  type = list(string)
  default = ["list, of, example, domains"]
}

variable "cw_logs_retention_period" {
  type = number
  default = 90
}