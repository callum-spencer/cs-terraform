output "task_definition_arn" {
  value = aws_ecs_task_definition.task.arn
}

output "ecs_with_alb_name" {
  value = length(aws_ecs_service.main_with_alb) > 0 ? aws_ecs_service.main_with_alb[0].name : "Null"
}