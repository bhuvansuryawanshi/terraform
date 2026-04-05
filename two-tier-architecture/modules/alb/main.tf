resource "aws_lb" "alb" {
  name                       = "${var.project_name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_sg_id]
  subnets                    = [var.pub_sub_1a_id, var.pub_sub_2b_id]
  enable_deletion_protection = false

  tags = {
    Environment = "${var.project_name}-alb"
  }
}


# target group
resource "aws_lb_target_group" "target_group" {
  name     = var.project_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    interval            = 300
    path                = "/"
    timeout             = 60
    matcher             = 200
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  lifecycle {
    create_before_destroy = true
  }
}

# created a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}