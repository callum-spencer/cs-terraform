resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = var.retention_period

  tags = {
    Name        = "${var.project_name}-log-group"
    Product     = "example"
    Subproduct  = var.project_name
    Environment = var.environment
    Accountable = "Example User"
    Dept        = "DevOpsing"
    Function    = "Cloudwatch log group for the ${var.project_name} project in the ${var.environment} environment."
  }
}