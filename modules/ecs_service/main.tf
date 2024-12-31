data "template_file" "task" {
  template = file("${path.module}/../../templates/${var.project_name}.json")

  vars = {
    app_image               = var.app_image
    cpu                     = var.fargate_cpu
    memory                  = var.fargate_memory
    memory_limit            = var.overall_memory
    aws_region              = var.aws_region
    app_port                = var.app_port
    app_port_protocol       = var.app_port_protocol
    environment             = var.environment
    environment_short       = var.environment_short
    cw_logs_appname         = var.project_name
    ecs_task_execution_role = var.ecs_task_execution_role
    task_execution_role_arn = var.ecs_task_execution_role
  }
}

data "aws_ecs_task_definition" "task" {
  task_definition = aws_ecs_task_definition.task.family
  depends_on = [aws_ecs_task_definition.task] 
}


resource "aws_ecs_task_definition" "task" {
  family                   = "${var.project_name}-task"
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.overall_cpu
  memory                   = var.overall_memory
  container_definitions    = data.template_file.task.rendered
  ephemeral_storage {
    size_in_gib = var.task_storage_in_gib
  }
}



# ECS Service with ALB
resource "aws_ecs_service" "main_with_alb" {
  count                 = var.application_lb ? 1 : 0
  name                  = "${var.project_name}-service"
  cluster               = var.ecs_cluster
  task_definition       = "${aws_ecs_task_definition.task.family}:${max(aws_ecs_task_definition.task.revision, data.aws_ecs_task_definition.task.revision)}"
  desired_count         = var.app_count
  launch_type           = "FARGATE"
  wait_for_steady_state = false

  network_configuration {
    security_groups = [var.ecs_task_secgrp_id]
    subnets         = var.private_subnet_ids
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.project_name
    container_port   = var.app_port
  }
  enable_execute_command   = true
}

# Example to show how we can allow selecting which resource to use with true or false flag as seen in projects/example-app-web/main.tf
resource "aws_ecs_service" "main_with_nlb" {
  count                 = var.network_lb ? 1 : 0
  name                  = "${var.project_name}-nlb-service"
  cluster               = var.ecs_cluster
  task_definition       = "${aws_ecs_task_definition.task.family}:${max(aws_ecs_task_definition.task.revision, data.aws_ecs_task_definition.task.revision)}"
  desired_count         = var.app_count
  launch_type           = "FARGATE"
  wait_for_steady_state = false

  network_configuration {
    security_groups = [var.ecs_task_secgrp_id]
    subnets         = var.private_subnet_ids
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.project_name
    container_port   = var.app_port
  }
  enable_execute_command   = true
}
