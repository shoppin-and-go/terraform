resource "aws_ecs_service" "api" {
  name            = var.service_api_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 1
  launch_type = "EC2"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.api.id]
  }
}

resource "aws_ecs_service" "db" {
  name            = var.service_db_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.db.arn
  desired_count   = 1
  launch_type = "EC2"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.db_sg.id]
  }
}

resource "aws_security_group" "api" {
  name        = "ecs-service-app-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "ecs-service-sg"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "ecs-service-db-sg"
  description = "Allow MySQL access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Name = "ecs-service-sg"
  }
}

resource "aws_lb" "api_lb" {
  name               = "api-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api.id]
  subnets            = var.subnet_ids

  tags = {
    Name = "api-lb"
  }
}

resource "aws_lb_target_group" "api_tg" {
  name     = "api-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/actuator/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-299"
  }

  tags = {
    Name = "api-tg"
  }
}

resource "aws_lb_listener" "api_listener" {
  load_balancer_arn = aws_lb.api_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_tg.arn
  }
}

output "load_balancer_dns" {
  value = aws_lb.api_lb.dns_name
}