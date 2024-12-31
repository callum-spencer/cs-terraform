
# Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "up" {
  name               = "${var.project_name}-${var.environment}_${var.scaling_metric_alarm_name}_scale_up"
  service_namespace  = "ecs"
  resource_id        = var.autoscaling_target_id
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

# Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "down" {
  name               = "${var.project_name}-${var.environment}_${var.scaling_metric_alarm_name}_scale_down"
  service_namespace  = "ecs"
  resource_id        = var.autoscaling_target_id
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

# Cloudwatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "service_high" {
  alarm_name          = "${var.project_name}-${var.environment}_${var.scaling_metric_alarm_name}_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.scaling_wait_time
  metric_name         = var.scaling_metric_name
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = var.scaling_metric_aggregation
  threshold           = var.scaling_up_threshold

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-cw-metric-alarm-${var.scaling_metric_name}-high"
    Product     = "example"
    Subproduct  = var.project_name
    Environment = var.environment
    Accountable = "Example User"
    Dept        = "DevOpsing"
    Function    = "Cloudwatch Metric alarm for scaling up in the ${var.project_name} project in the ${var.environment} environment."
  }

  alarm_actions = [aws_appautoscaling_policy.up.arn]
}

# Cloudwatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "service_low" {
  alarm_name          = "${var.project_name}-${var.environment}_${var.scaling_metric_alarm_name}_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.scaling_wait_time
  metric_name         = var.scaling_metric_name
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = var.scaling_metric_aggregation
  threshold           = var.scaling_down_threshold

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = var.ecs_service_name
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-cw-metric-alarm-${var.scaling_metric_alarm_name}-low"
    Product     = "example"
    Subproduct  = var.project_name
    Environment = var.environment
    Accountable = "Example User"
    Dept        = "DevOpsing"
    Function    = "Cloudwatch Metric alarm for scaling down in the ${var.project_name} project in the ${var.environment} environment."
  }

  alarm_actions = [aws_appautoscaling_policy.down.arn]
}