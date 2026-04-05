# default vpc
resource "aws_default_vpc" "vpc" {
  tags = {
    Name = "Default VPC"
  }
}

# Get default subnets
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.vpc.id]
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.project-name}-${var.env}-alb-sg"
  description = "ALB security group"
  vpc_id      = aws_default_vpc.vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project-name}-${var.env}-alb-sg"
  }
}

resource "aws_security_group" "ecs_sg" {
  name        = "${var.project-name}-${var.env}-ecs-sg"
  description = "ECS tasks security group"
  vpc_id      = aws_default_vpc.vpc.id

  ingress {
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "Allow ALB to reach tasks"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project-name}-${var.env}-ecs-sg"
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project-name}-${var.env}-task-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_lb" "alb" {
  name               = "${var.project-name}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb_sg.id]
  tags = { Name = "${var.project-name}-${var.env}-alb" }
}

resource "aws_lb_target_group" "tg" {
  name        = "${var.project-name}-${var.env}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = aws_default_vpc.vpc.id
  target_type = "ip"
  
  health_check {
    path                = "/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_ecs_cluster" "ecs-cluster" {
    name = "${var.project-name}-${var.env}-cluster"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project-name}-${var.env}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = tostring(var.cpu)
  memory                   = tostring(var.memory)
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

runtime_platform {
  cpu_architecture        = "ARM64"
  operating_system_family = "LINUX"
}

  container_definitions = jsonencode([{
    name      = "flask-app"
    image     = "${var.ecr_repository_url}:${var.image_tag}"
    portMappings = [{ containerPort = var.container_port, protocol = "tcp" }]
    essential = true
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.project-name}-${var.env}"
        "awslogs-region"        = var.region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project-name}-${var.env}"
  retention_in_days = 7
}

resource "aws_ecs_service" "this" {
  name             = "${var.project-name}-${var.env}-service"
  cluster          = aws_ecs_cluster.ecs-cluster.id
  launch_type      = "FARGATE"
  desired_count    = var.desired_count
  task_definition  = aws_ecs_task_definition.this.arn
  platform_version = "LATEST"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "flask-app"
    container_port   = var.container_port
  }

  depends_on = [aws_lb_listener.http]
}