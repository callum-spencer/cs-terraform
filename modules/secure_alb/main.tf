data "aws_acm_certificate" "pw_cert" {
  domain      = var.alb_certificate
  statuses    = ["ISSUED"]
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_alb" "main" {
  name            = var.project_name
  subnets         = var.public_subnet_ids
  internal        = var.internal_lb
  security_groups = [aws_security_group.lb.id]
  idle_timeout    = var.lb_idle_timeout
  tags = {
    Name        = "${var.project_name}-alb"
    Product     = "example"
    Subproduct  = var.project_name
    Environment = var.environment
    Accountable = "Example User"
    Dept        = "DevOps"
    Function    = "ALB for the ${var.project_name} project in the ${var.environment} environment."
    datadog     = "monitored"
  }
}

resource "aws_alb_target_group" "target_group" {
  name        = "${var.project_name}-tg"
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    interval            = var.health_check_interval
    protocol            = var.target_group_protocol
    matcher             = var.health_check_expected_port
    timeout             = var.health_check_timeout
    path                = var.health_check_path
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }
  tags = {
    Name        = "${var.project_name}-tg"
    Product     = "example"
    Subproduct  = var.project_name
    Environment = var.environment
    Accountable = "Example User"
    Dept        = "DevOps"
    Function    = "Target-group for the ${var.project_name} project in the ${var.environment} environment."
  }
}

# Return "Access Denied by default"
resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.pw_cert.arn
  depends_on        = [aws_alb_target_group.target_group]

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Access Denied"
      status_code  = "403"
    }
  }
}

# Redirect all traffic to the target group if visitng through approved url
resource "aws_lb_listener_rule" "allow_specific_domain" {
  listener_arn = aws_alb_listener.listener.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.target_group.arn
  }

  condition {
    host_header {
      values = var.application_domains
    }
  }
}

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_alb.main.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_alb_listener.listener]

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Access Denied"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "allow_specific_domain_http" {
  listener_arn = aws_alb_listener.listener_http.arn
  priority     = 10

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = var.alb_redirect_status_code
    }
  }

  condition {
    host_header {
      values = var.application_domains
    }
  }
}