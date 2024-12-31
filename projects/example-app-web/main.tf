data "aws_iam_role" "ecs_task_execution_role" {
  name = "ECSTaskExecutionRole"
}

data "aws_route53_zone" "selected" {
  name         = "${var.environment_short}.example.com"
}

module "ecr" {
  source                  = "./modules/ecr"
  environment             = var.environment
  project_name            = var.project_name
  aws_region              = var.aws_region
}

module "alb" {
  source                           = "./modules/secure_simple_alb"
  aws_region                       = var.aws_region
  project_name                     = var.project_name
  environment_short                = var.environment_short
  environment                      = var.environment
  vpc_id                           = var.vpc_id
  alb_certificate                  = var.acm_certificate
  public_subnet_ids                = var.public_subnet_ids
  target_group_port                = var.target_group_port
  target_group_protocol            = var.target_group_protocol
  health_check_path                = var.health_check_path
  health_check_expected_port       = var.health_check_expected_port
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_interval            = var.health_check_interval
  health_check_timeout             = var.health_check_timeout
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  alb_redirect_status_code         = var.alb_redirect_status_code
  application_domains              = var.application_domains
}

module "logs" {
  source           = "./modules/cw_logs"
  project_name     = var.project_name
  environment      = var.environment
  retention_period = var.cw_logs_retention_period
}

module "ecs" {
  source                  = "./modules/ecs_service"
  project_name            = var.project_name
  environment             = var.environment
  app_image               = var.app_image
  fargate_cpu             = var.fargate_cpu
  fargate_memory          = var.fargate_memory
  overall_cpu             = var.overall_cpu
  overall_memory          = var.overall_memory
  aws_region              = var.aws_region
  app_port                = var.app_port
  app_port_protocol       = var.app_port_protocol
  task_execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
  vpc_id                  = var.vpc_id
  private_subnet_ids      = var.private_subnet_ids
  lb_sg_id                = module.alb.alb_security_group_id
  target_group_arn        = module.alb.alb_target_group_arn
  app_count               = var.app_count
  ecs_cluster             = var.ecs_cluster_name
  application_lb          = true
  no_lb                   = false
  classic_lb              = false
  network_lb              = false
  link_to_lb              = false
  ecs_task_secgrp_id      = module.ecs_task_secgrp.security_group_id
}

module "ecs_task_secgrp" {
  source = "terraform-aws-modules/security-group/aws"
  version = "4.4.0"
  name        = "${var.project_name}-ecs-tasks-security-group"
  description = "Allow inbound access from the ALB only"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
      {
      from_port   = var.app_port
      to_port     = var.app_port
      protocol    = "tcp"
      description = "Ingress from ALB"
      source_security_group_id = module.alb.alb_security_group_id
    },
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = var.app_port
      to_port     = var.app_port
      protocol    = "tcp"
      description = "Web access in from VPN" # Assume we have some internal VPN to allow users to SSH into container if needs be
      cidr_blocks = "10.0.0.0/16"
    },
  ]

  egress_with_cidr_blocks = [
      {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "All access outbound."
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = {
    Name        = "${var.project_name}-${var.environment}-ecs-sg"
    Product     = "example"
    Subproduct  = var.project_name
    Environment = var.environment
    Accountable = "Example User"
    Dept        = "DevOpsing"
    Function    = "ECS service SG for the ${var.project_name} project in the ${var.environment} environment."
  }
}

resource "aws_appautoscaling_target" "target" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${module.ecs.ecs_with_alb_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn           = var.ecs_autoscale_role
  min_capacity       = var.scaling_min_count
  max_capacity       = var.scaling_max_count
}

module "ecs_cpu_scaling_policy" {
  source                    = "./modules/ecs_asg_policies"
  ecs_cluster_name          = var.ecs_cluster_name  
  ecs_service_name          = module.ecs.ecs_with_alb_name
  project_name              = var.project_name
  scaling_metric_name       = "CPUUtilization"
  scaling_metric_alarm_name = "cpu_utilization"
  environment               = var.environment
  scaling_up_threshold      = var.scaling_up_cpu_threshold
  scaling_down_threshold    = var.scaling_down_cpu_threshold
  autoscaling_target_id     = aws_appautoscaling_target.target.resource_id
  scaling_wait_time         = var.scaling_wait_time
  scaling_metric_aggregation = var.scaling_cpu_metric_aggregation

  depends_on = [aws_appautoscaling_target.target]
}

resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.dns_subdomain
  ttl     = 30
  type    = "CNAME"
  records = [module.alb.alb_cname]

  lifecycle {
    ignore_changes = [
      records
    ]
  }  
}