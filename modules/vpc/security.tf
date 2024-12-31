resource "aws_security_group" "ecs_task" {
  vpc_id = aws_vpc.main.id
  name   = "${var.project_name}-ecs-task-sg"

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Customize as per security requirements
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-ecs-task-sg"
    Product     = var.product_name
    Subproduct  = var.project_name
    Environment = var.environment
    Accountable = "Example User"
    Dept        = "DevOpsing"
    Function    = "Security Group for ECS Tasks in ${var.environment} environment"
  }
}